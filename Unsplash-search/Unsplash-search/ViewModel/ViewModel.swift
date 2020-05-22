//
//  ViewModel.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 18/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import Foundation
import UIKit

struct CellViewModel {
    let image: UIImage
    let photoId: String?
}

class ViewModel {
    private let apiClient: APIClient
    private var photos: Photos = [] {
        didSet {
            self.fetchPhoto()
        }
    }
    var cellViewModels: [CellViewModel] = []
    
    var isLoading: Bool = false {
        didSet {
            showInfinityLoading?()
        }
    }
    
    var isSearching: Bool = false {
        didSet {
            searching?()
        }
    }
    
    var showInfinityLoading: (() -> Void)?
    var searching: (() -> Void)?
    var reloadData: (() -> Void)?
    var showError:  ((Error) -> Void)?
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchPhotos(page: Int, searching: Bool?, text: String?) {
        if let client = apiClient as? UnsplashClient {
            self.isLoading = true
            switch searching {
            case true:
                let endpoint = UnsplashEndpoint.search(id: UnsplashClient.apiKey, text: text!, page: page)
                client.searchImages(with: endpoint) { (response) in
                    switch response {
                        case .success(let photos):
                            let searchedPhoto: SearchedPhoto = photos
                            self.photos = searchedPhoto.results
                        case .error(let error):
                            self.showError?(error)
                        default:
                            break
                    }
                }
            case false:
                let endpoint = UnsplashEndpoint.photos(id: UnsplashClient.apiKey, order: .popular, page: page)
                client.fetchImages(with: endpoint) { (response) in
                    switch response {
                        case .success(let photos):
                            self.photos = photos
                        case .error(let error):
                            self.showError?(error)
                        default:
                            break
                    }
                }
            default:
                break
            }
    
        }
    }
    
    func searchPhotos(text: String) {
        self.isSearching = true
        self.cellViewModels.removeAll()
        self.cellViewModels = []
        if let client = apiClient as? UnsplashClient {
            self.isLoading = true
            let endpoint = UnsplashEndpoint.search(id: UnsplashClient.apiKey, text: text, page: 1)
            client.searchImages(with: endpoint) { (response) in
                switch response {
                    case .success(let photos):
                        let searchedPhoto: SearchedPhoto = photos
                        self.photos = searchedPhoto.results
                    case .error(let error):
                        self.showError?(error)
                }
            }
        }
    }
    
    
    func fetchPhoto() {
        let group = DispatchGroup()
        self.photos.forEach { (photo) in
            DispatchQueue.global(qos: .background).async(group: group) {
                group.enter()
                guard let imageData = try? Data(contentsOf: photo.urls.regular) else {
                    self.showError?(APIError.imageDownload)
                    return
                }
                
                guard let image = UIImage(data: imageData) else {
                    self.showError?(APIError.imageConvert)
                    return
                }
                
                self.cellViewModels.append(CellViewModel(image: image, photoId: photo.id))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.isLoading = false
            self.isSearching = false
            self.reloadData?()
        }
    }
    
    
}
