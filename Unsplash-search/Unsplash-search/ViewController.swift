//
//  ViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchInput: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchInput.delegate = self
    }

    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchInput.endEditing(true)
        makeSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchInput.endEditing(true)
        makeSearch()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchInput.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchInput.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func makeSearch() {
        if let url = URL.with(string: "photos/random?count=2") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("wC3_jyA6NlQL0kPY2_YEd-SEWQbhQF5OphfqgkmQbAw", forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
            
            task.resume()
        }
    }
    
}

extension URL {
    private static var baseUrl: String {
        return "https://api.unsplash.com/"
    }
    
    static func with(string: String) -> URL? {
        return URL(string: "\(baseUrl)\(string)")
    }
}

