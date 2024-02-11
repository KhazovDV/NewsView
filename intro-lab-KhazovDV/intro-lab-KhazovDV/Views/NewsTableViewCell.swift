//
//  NewsTableViewCell.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    // Begin Constants
    private static let imageSide: CGFloat = 140
    private static let imadeCornerRadius: CGFloat = 8
    private static let imageName: String = "newsLogo"

    private static let spacing: CGFloat = 8

    private static let maxOffset: CGFloat = 16
    private static let minOffset: CGFloat = 8
    // End Constants

    static let reuseIdentifier: String = String(describing: self)

    private var model: NewsModel?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let newsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.layer.cornerRadius = NewsTableViewCell.imadeCornerRadius
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        return label
    }()

    private let hStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.spacing = NewsTableViewCell.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupSubviews() {
        addSubview(hStackView)
        addSubview(viewsLabel)
        hStackView.addArrangedSubview(titleLabel)
        hStackView.addArrangedSubview(newsImage)

        NSLayoutConstraint.activate([
            hStackView.topAnchor.constraint(
                equalTo: topAnchor, constant: NewsTableViewCell.maxOffset
            ),
            hStackView.leftAnchor.constraint(
                equalTo: leftAnchor, constant: NewsTableViewCell.maxOffset
            ),
            hStackView.rightAnchor.constraint(
                equalTo: rightAnchor, constant: -NewsTableViewCell.maxOffset
            ),

            newsImage.heightAnchor.constraint(equalToConstant: NewsTableViewCell.imageSide),
            newsImage.widthAnchor.constraint(equalToConstant: NewsTableViewCell.imageSide),

            viewsLabel.topAnchor.constraint(
                equalTo: hStackView.bottomAnchor, constant: NewsTableViewCell.minOffset
            ),
            viewsLabel.leftAnchor.constraint(
                equalTo: leftAnchor, constant: NewsTableViewCell.maxOffset
            ),
            viewsLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor, constant: -NewsTableViewCell.maxOffset
            ),
        ])
    }

    func configure(model: NewsModel) {
        self.model = model
        titleLabel.text = model.title
        viewsLabel.text =  "Просмотров: \(model.views)"
        newsImage.image = UIImage(named: NewsTableViewCell.imageName)

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
}
