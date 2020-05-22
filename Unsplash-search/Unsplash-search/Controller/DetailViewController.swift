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
    
    @IBAction func onInfoButtonTapped(_ sender: UIBarButtonItem) {
        
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        transparentView.frame = self.view.frame
        transparentView.alpha = 0.0
        window?.addSubview(transparentView)
        
        let screenSize = UIScreen.main.bounds.size
        bottomView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        window?.addSubview(bottomView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.bottomView.frame = CGRect(x: 0, y: screenSize.height - 250, width: screenSize.width, height: 250)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.bottomView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 250)
        }, completion: nil)
    }
    
    var transparentView = UIView()
    var bottomView = UITableView()
    var image: UIImage!
    var id: String!
    let unsplashClient = UnsplashClient()
    var singlePhoto: SinglePhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        navigationItem.title = "Photo detail"
        
        print("ID \(id)")
        
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
