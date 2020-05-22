//
//  ApiClient.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(Error)
}

enum APIError: Error {
    case unknown, badResponse, jsonDecoder, imageDownload, imageConvert
}

protocol APIClient {
    var session: URLSession { get }
    func get<T: Codable>(with request: URLRequest, completion: @escaping (Response<[T]>) -> Void)
}

extension APIClient {
    var session: URLSession {
        return URLSession.shared
    }
    
    func get<T: Codable>(with request: URLRequest, completion: @escaping (Response<[T]>) -> Void) {
        print(request)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("ERROR IN RESPONSE")
                return
            }
            
            
            guard let value = try? JSONDecoder().decode([T].self, from: data!) else {
                print("ERROR IN DECODER")
                return
            }
        
            
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
    
    func search<T: Codable>(with request: URLRequest, completion: @escaping (Response<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("Error: RESPONSE!")
                return
            }
            
            
            guard let value = try? JSONDecoder().decode(T.self, from: data!) else {
                print("Error: DECODER!")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
    
    func getOne<T: Codable>(with request: URLRequest, completion: @escaping (Response<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.error(error!))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                print("Error: RESPONSE!")
                return
            }
            
            
            guard let value = try? JSONDecoder().decode(T.self, from: data!) else {
                print("Error: DECODER!")
                return
            }
            
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
}
