//
//  UnsplashClient.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

typealias Photos = [Photo]

struct Photo: Codable {
    let id: String
    let description: String?
    let urls: URLS
//    let usxer: User?
    
//    init(id: String, description: String, urls: URLS, user: User) {
//        self.id = id
//        self.description = description
//        self.urls = urls
//        self.user = user
//    }
}

struct SinglePhoto: Codable {
    let id: String?
    let urls: URLS
    let description: String?
    let likes: Int? = 0
    let liked_by_user: Bool
    let user: User?
}

struct User: Codable {
    let id: String?
    let name: String?
    let bio: String?
    
//    init(id: String, name: String, bio: String) {
//        self.id = id
//        self.name = name
//        self.bio = bio
//    }
}

struct SearchedPhoto: Codable {
    let total: Int
    let total_pages: Int
    let results: Photos
}

struct URLS: Codable {
    let raw: URL
    let full: URL
    let regular: URL
    let small: URL
    let thumb: URL
}
