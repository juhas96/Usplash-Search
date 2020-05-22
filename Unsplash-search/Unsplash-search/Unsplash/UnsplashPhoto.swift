//
//  UnsplashPhoto.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 19/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation
import UIKit

private let baseURL = "https://api.unsplash.com"
private let apiKey = "wC3_jyA6NlQL0kPY2_YEd-SEWQbhQF5OphfqgkmQbAw"

class UnsplashPhoto: Codable {
    let id: String
    let description: String
    let urls: URLS
    let user: User
    
    enum Error: Swift.Error {
        case invalidURL
        case noData
    }
    
    var session: URLSession {
        return URLSession.shared
    }
    
    func fetchRandomImages(with request: URLRequest, completion: @escaping(Result<[UnsplashPhoto]>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(Result.error(error))
                }
                return
            }
            
            guard let value = try? JSONDecoder().decode([UnsplashPhoto].self, from: data!) else {
                DispatchQueue.main.async {
                    completion(Result.error(Error.noData))
                }
                return
            }
            DispatchQueue.main.async {
                completion(Result.results(value))
            }
        }
        
        task.resume()
    }
    
}
