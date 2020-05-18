//
//  Image.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

struct Image: Decodable {
    let id: String
    let width: Int
    let height: Int
    let likes: Int
    let color: String
    let urls: URLs
    let keyNotExist: String?
}
