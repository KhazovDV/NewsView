//
//  NewsDetailViewController.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class NewsDetailViewController: UIViewController {
    // Begin Constants
    private static let imadeCornerRadius: CGFloat = 8
    private static let imageName: String = "newsLogo"

    private static let spacing: CGFloat = 8

    private static let maxOffset: CGFloat = 16
    private static let minOffset: CGFloat = 8
    // End Constants

    private var model: NewsModel?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()

    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()

    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.layer.cornerRadius = NewsDetailViewController.imadeCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let linkTextView: InteractiveTextView = {
        let textView = InteractiveTextView()
        textView.textColor = .gray
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private let vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = NewsDetailViewController.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    func configure(model: NewsModel) {
        self.model = model
        titleLabel.text = model.title
        newsImage.image = UIImage(named: NewsDetailViewController.imageName)
        descriptionLabel.text = model.description
        dateLabel.text = "Дата публикации: \(model.date)"
        sourceLabel.text = "Источник: \(model.source)"
        linkTextView.attributedText = NSAttributedString(
            string: "Ссылка на новость: \(model.url)",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18),
                NSAttributedString.Key.foregroundColor: UIColor.gray
            ]
        )
        linkTextView.setLink(url: model.url) { [weak self] url in
            let browserViewController = NewsBrowserViewController()
            browserViewController.link = url
            self?.present(browserViewController, animated: true, completion: nil)
        }

        guard let url = model.urlToImage else { return }

        ImageLoader.shared.downloadImage(from: url) { [weak self] loadedImage, urlToImage in
            guard
                let self = self,
                let image = loadedImage,
                self.model?.urlToImage == urlToImage  // Обработка ситуации, когда новая ячейка загружена, а сработала загрузка старой картинки (проверяем на соответствие)
            else {
                return
            }
            DispatchQueue.main.async {
                self.newsImage.image = image
            }
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(vStackView)
        vStackView.addArrangedSubview(titleLabel)
        vStackView.addArrangedSubview(newsImage)
        vStackView.addArrangedSubview(descriptionLabel)
        vStackView.addArrangedSubview(dateLabel)
        vStackView.addArrangedSubview(sourceLabel)
        vStackView.addArrangedSubview(linkTextView)

        NSLayoutConstraint.activate([
            newsImage.widthAnchor.constraint(
                equalTo: vStackView.widthAnchor
            ),
            newsImage.heightAnchor.constraint(
                equalTo: newsImage.widthAnchor
            ),

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: NewsDetailViewController.maxOffset
            ),
            scrollView.leftAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: NewsDetailViewController.maxOffset
            ),
            scrollView.rightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -NewsDetailViewController.maxOffset
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -NewsDetailViewController.maxOffset
            ),

            vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            vStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}
