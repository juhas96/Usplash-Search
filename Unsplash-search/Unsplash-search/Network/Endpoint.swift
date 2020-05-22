//
//  Endpoint.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var urlParameters: [URLQueryItem] { get }
}

extension Endpoint {
    var urlComponent: URLComponents {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = urlParameters
        
        return urlComponent!
    }
    
    var request: URLRequest {
        return URLRequest(url: urlComponent.url!)
    }
}

enum Order: String {
    case popular, latest, oldest
}

enum UnsplashEndpoint: Endpoint {
    case photos(id: String, order: Order, page: Int)
    case search(id: String, text: String, page: Int)
    case singlePhoto(id: String, photoId: String)
    
    var baseUrl: String {
        return "https://api.unsplash.com"
    }
    
    var path: String {
        switch self {
        case .photos:
            return "/photos"
        case .search:
            return "/search/photos"
        case .singlePhoto(_, let photoId):
            return "/photos/" + photoId
        }
    }
    
    var urlParameters: [URLQueryItem] {
        switch self {
        case .photos(let id, let order, let page):
            return [
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "order_by", value: order.rawValue),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .search(let id, let text, let page):
            return [
                URLQueryItem(name: "client_id", value: id),
                URLQueryItem(name: "query", value: text),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .singlePhoto(let id, _):
            return [
                URLQueryItem(name: "client_id", value: id),
            ]
        }
    }
}
