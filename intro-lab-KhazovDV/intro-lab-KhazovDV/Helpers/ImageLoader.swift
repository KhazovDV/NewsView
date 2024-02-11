//
//  ImageLoader.swift
//  intro-lab-KhazovDV
//
//  Created by garpun on 05.02.2023.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()

    private var cache = NSCache<NSString, UIImage>()

    func downloadImage(from urlToImage: String, completed: @escaping (UIImage?, String) -> Void) {
        let cacheKey = NSString(string: urlToImage)

        if let image = cache.object(forKey: cacheKey) {
            completed(image, urlToImage)
            return
        }

        guard let url = URL(string: urlToImage) else {
            completed(nil, urlToImage)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data)
            else {
                completed(nil, urlToImage)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image, urlToImage)
        }

        task.resume()
    }
}
