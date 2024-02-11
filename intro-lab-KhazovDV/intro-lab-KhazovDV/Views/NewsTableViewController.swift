//
//  NewsTableViewController.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class NewsTableViewController: UIViewController {
    // Begin Constants
    private static let navigationTitle: String = "Новости"
    private static let pullTitle: String = "Потяните, чтобы обновить"

    private static let firstPage: Int = 1

    private static let offset: CGFloat = 8
    // End Constants

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var pullControl: UIRefreshControl = {
        let controll = UIRefreshControl()
        controll.attributedTitle = NSAttributedString(string: NewsTableViewController.pullTitle)
        return controll
    }()

    private var isRU: Bool = true

    @Storage(key: "com.news.models.ru", defaultValue: []) private var models: [NewsModel]

    private var pageCount: Int = firstPage

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupPullControl()
        setupTableView()
        setupNavigationBar()
        setupSubviews()

        if models.isEmpty {
            fetchData(with: pageCount)
        }
    }

    private func fetchData(with page: Int, completed: (() -> Void)? = nil) {
        NewsLoader.fetchNews(with: page) { [weak self] models, loaderError in
            defer { completed?() }
            guard loaderError == nil else {
                if let loaderError = loaderError {
                    self?.handleLoadingErrors(error: loaderError)
                }
                return
            }

            guard let self = self else { return }

            DispatchQueue.main.async {
                guard let models = models else {
                    return
                }
                let newValues = models.filter { model in
                    !self.models.contains(model)
                }
                self.models.append(contentsOf: newValues)
                self.models.sort(by: >)
                self.tableView.reloadData()
            }
        }
    }

    private func handleLoadingErrors(error: NewsLoader.LoaderError) {
        var alertView: UIAlertController

        switch error {
        case .networkError: alertView = AlertFactory.makeNetworkErrorAlert()
        case .endOfHistory: alertView = AlertFactory.makeEndOfHistoryAlert()
        }

        DispatchQueue.main.async {
            self.present(alertView, animated: true)
        }
    }

    @objc func refreshModels() {
        fetchData(with: NewsTableViewController.firstPage) {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.pullControl.endRefreshing()
            }
        }
    }

    private func setupPullControl() {
        pullControl.addTarget(self, action: #selector(refreshModels), for: .valueChanged)
        tableView.refreshControl = pullControl
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(
            NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier
        )
    }

    private func setupNavigationBar() {
        navigationItem.title = NewsTableViewController.navigationTitle
    }

    private func setupSubviews() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: NewsTableViewController.offset
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -NewsTableViewController.offset
            ),
            tableView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: NewsTableViewController.offset
            ),
            tableView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -NewsTableViewController.offset
            ),
        ])
    }
}

extension NewsTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        models[indexPath.row].views = models[indexPath.row].views + 1
        tableView.reloadRows(at: [indexPath], with: .none)

        let detail = NewsDetailViewController()
        detail.configure(model: models[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }
}

extension NewsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier) as? NewsTableViewCell
        else { return UITableViewCell() }

        cell.configure(model: models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == models.count && indexPath.row + 1 / 20 > pageCount {
            pageCount = pageCount + 1
            fetchData(with: pageCount)
        }
    }
}
