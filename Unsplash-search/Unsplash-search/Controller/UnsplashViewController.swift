//
//  UnsplashViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 19/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit

private let reuseIdentifier = "UnsplashCell"
private let itemsPerRow: CGFloat = 2

class UnsplashViewController: UICollectionViewController, UITextFieldDelegate {
    
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    let viewModel = ViewModel(apiClient: UnsplashClient())
    @IBOutlet weak var searchField: UITextField!
    
    struct Storyboard {
//        static let photoCell = "UnsplashCell"
//        static let leftAndRightPaddings: CGFloat = 2.0
//        static let numberOfItemsPerRow: CGFloat = 2.0
    }
//
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
        
        //            searchInput = UITextField(frame: CGRect(x: 10.0, y: 50.0, width: UIScreen.main.bounds.size.width - 20.0, height: 50.0))
        //            searchInput.borderStyle = .line
        //            searchInput.keyboardType = .default
        //            searchInput.placeholder = "Enter something to search images"
        //            searchInput.font = UIFont.systemFont(ofSize: 15.0)
        //            searchInput.delegate = self
        //            self.view.addSubview(searchInput)
        //
        //            if let layout = collectionView.collectionViewLayout as? PinterestLayout {
        //                layout.delegate = self
        //            }
        //            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.searchPhotos(text: textField.text!)
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
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UnsplashCell
        DispatchQueue.main.async {
            let image = self.viewModel.cellViewModels[indexPath.item].image
            cell.imageView.image = image
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected: " )
    }
}


extension UnsplashViewController : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.safeAreaLayoutGuide.layoutFrame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: 150, height: 150)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    

}

//
