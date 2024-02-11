//
//  NewsLoader.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import Foundation

struct News: Codable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Codable {
    struct Source: Codable {
        var id: String?
        var name: String
    }
    var source: Source
    var id: String?
    var name: String?
    var author: String?
    var title: String
    var description: String?
    var url: String
    var urlToImage: String?
    var publishedAt: String
    var content: String?
}

enum NewsLoader {
    enum LoaderError {
        case endOfHistory
        case networkError
    }

    private static let apiKey = "71f9e062be0b4960a18c28bf3782eef8"
//    private static let apiKey = "124e256bd16440058a40aa7d7eeee929"

    private static func endpointString(page: Int = 1) -> String {
        "https://newsapi.org/v2/top-headlines?country=ru&pageSize=20&page=\(page)&apiKey=\(apiKey)"
    }

    static func fetchNews(with page: Int = 1, completed: @escaping ([NewsModel]?, LoaderError?) -> Void) {
        loadNews(with: page) { news, error in
            guard let news = news else {
                completed(nil, error)
                return
            }
            completed(news.articles.map { NewsAdapter.getModel(with: $0) }, error)
            
        }
    }

    private static func loadNews(with page: Int = 1, completed: @escaping (News?, LoaderError?) -> Void) {
        guard let url = URL(string: endpointString(page: page)) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse
            else {
                completed(nil, .networkError)
                return
            }

            guard
                response.statusCode == 200,
                let data = data
            else {
                if response.statusCode == 426 {
                    completed(nil, .endOfHistory)
                    return
                } else {
                    completed(nil, .networkError)
                    return
                }
            }
    
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                completed(news, nil)
            } catch (let jsonError) {
                print(jsonError)
                completed(nil, nil)
            }
            
        }
        task.resume()
    }
}
