//
//  NewsAdapter.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import Foundation

enum NewsAdapter {
    static func getModel(with data: Article) -> NewsModel {
        NewsModel(
            id: data.id,
            name: data.name,
            author: data.author,
            title: data.title,
            description: data.description,
            url: data.url,
            urlToImage: data.urlToImage,
            publishedAt: data.publishedAt,
            content: data.content,
            source: [data.source.id, data.source.name].compactMap{ $0 }.joined(separator: " "),
            views: 0
        )
    }
}
