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
    let description: String
    let urls: URLS
    let user: User
    
    init(id: String, description: String, urls: URLS, user: User) {
        self.id = id
        self.description = description
        self.urls = urls
        self.user = user
    }
}

struct User: Codable {
    let id: String
    let name: String
    let bio: String
    
    init(id: String, name: String, bio: String) {
        self.id = id
        self.name = name
        self.bio = bio
    }
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
    
    init(raw: URL, full: URL, regular: URL, small: URL, thumb: URL) {
        self.raw = raw
        self.full = full
        self.regular = regular
        self.small = small
        self.thumb = thumb
    }
}
