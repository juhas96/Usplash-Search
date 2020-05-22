//
//  ViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: Properties
    var searchInput: UITextField!
    let viewModel = ViewModel(apiClient: UnsplashClient())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.showLoading = {
            if self.viewModel.isLoading {
                // TODO: Show loading
//                self.activityIndicator.startAnimating()
                self.collectionView.alpha = 0.0
            } else {
//                self.activityIndicator.stopAnimating()
                self.collectionView.alpha = 10.0
            }
        }
        
        viewModel.showError = { error in
            print(error)
        }
        
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }
        
        viewModel.fetchPhotos()
        
        searchInput = UITextField(frame: CGRect(x: 10.0, y: 50.0, width: UIScreen.main.bounds.size.width - 20.0, height: 50.0))
        searchInput.borderStyle = .line
        searchInput.keyboardType = .default
        searchInput.placeholder = "Enter something to search images"
        searchInput.font = UIFont.systemFont(ofSize: 15.0)
        searchInput.delegate = self
        self.view.addSubview(searchInput)
        
//        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
//            layout.delegate = self
//        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
//    @IBAction func searchButtonPressed(_ sender: UIButton) {
//        self.apiClient.makeSearch(text: searchInput.text!)
//        searchInput.endEditing(true)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        viewModel.searchPhotos(text: textField.text!)
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}

// MARK: Flow layout
//extension ViewController: PinterestLayoutDelegate {
//    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
//        let image = viewModel.cellViewModels[indexPath.item].image
//        return CGFloat(image.size.height)
//    }
//}

// MARK: Data source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let image = viewModel.cellViewModels[indexPath.item].image
        
        cell.imageView.image = image
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.viewModel.cellViewModels[indexPath.item])
//        if #available(iOS 13.0, *) {
//            let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
//            self.navigationController?.pushViewController(vc!, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
    }
}
