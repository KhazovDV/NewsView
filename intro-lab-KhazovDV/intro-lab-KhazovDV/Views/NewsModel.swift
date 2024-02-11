//
//  NewsModel.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import Foundation

struct NewsModel: Codable, Equatable, Comparable {
    var id: String?
    var name: String?
    var author: String?
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
    var source: String

    var views: Int

    var date: String {
        guard let date = publishedAt.toDate() else { return "-" }
        return date.toString()
    }

    static func < (lhs: NewsModel, rhs: NewsModel) -> Bool {
        lhs.date < rhs.date
    }

    static func == (lhs: NewsModel, rhs: NewsModel) -> Bool {
        lhs.url == rhs.url
    }
}
