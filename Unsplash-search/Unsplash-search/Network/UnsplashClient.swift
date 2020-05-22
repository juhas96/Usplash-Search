//
//  UnsplashClient.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

class UnsplashClient: APIClient {
    static let baseURL = "https://api.unsplash.com"
    static let apiKey = "wC3_jyA6NlQL0kPY2_YEd-SEWQbhQF5OphfqgkmQbAw"
    
    func fetchImages(with endpoint: UnsplashEndpoint, completion: @escaping (Response<Photos>) -> Void) {
        let request = endpoint.request
        get(with: request, completion: completion)
    }
    
    func searchImages(with endpoint: UnsplashEndpoint, completion: @escaping (Response<SearchedPhoto>) -> Void) {
        let request = endpoint.request
        search(with: request, completion: completion)
    }
    
    func fetchSingleImage(with endpoint: UnsplashEndpoint, completion: @escaping (Response<SinglePhoto>) -> Void) {
        let request = endpoint.request
        getOne(with: request, completion: completion)
    }
}
