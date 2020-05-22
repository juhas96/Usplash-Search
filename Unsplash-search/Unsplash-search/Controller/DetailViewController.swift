//
//  DetailViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 21/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorBio: UITextView!
    
    var image: UIImage!
    var id: String!
    let unsplashClient = UnsplashClient()
    var singlePhoto: SinglePhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        navigationItem.title = ""
        
        fetchPhoto()
        
    }
    
    func fetchPhoto() {
        let endpoint = UnsplashEndpoint.singlePhoto(id: UnsplashClient.apiKey, photoId: self.id)
        unsplashClient.fetchSingleImage(with: endpoint) { (response) in
            switch response {
                case .success(let photo):
                    self.navigationItem.title = photo.user?.name
                    self.descriptionText.text = photo.description
                    self.authorBio.text = photo.user?.bio
                    print(photo)
                case .error(let error):
                    print("Error: \(error.localizedDescription)")
            }
        }
    }
    

}
