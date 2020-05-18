//
//  DetailViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    let id: String = ""
    let apiClient = UnsplashClient()
    var photo: Photo = Photo(id: "", description: "", urls: URLS(raw: URL(string: "")!, full: URL(string: "")!, regular: URL(string: "")!, small: URL(string: "")!, thumb: URL(string: "")!), user: User(id: "", name: "", bio: ""))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let endpoint = UnsplashEndpoint.singlePhoto(id: UnsplashClient.apiKey, photoId: id)
        apiClient.fetchSingleImage(with: endpoint) { (response) in
            switch response {
                case .success(let photo):
                    self.photo = photo
                case .error(let error):
                    print("Error getting information about single image")
            }
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
