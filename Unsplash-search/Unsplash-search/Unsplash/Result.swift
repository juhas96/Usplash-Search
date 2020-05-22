//
//  Result.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 19/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

enum Result<ResultType> {
    case results(ResultType)
    case error(Error)
}
