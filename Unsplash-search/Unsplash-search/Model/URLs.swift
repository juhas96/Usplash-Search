//
//  URLs.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

struct URLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
