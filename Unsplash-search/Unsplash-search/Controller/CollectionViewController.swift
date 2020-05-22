//
//  CollectionViewController.swift
//  Unsplash-search
//
//  Created by Jakub Juhas on 21/05/2020.
//  Copyright © 2020 Jakub Juhas. All rights reserved.
//

import UIKit
import UserNotifications

class CollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var state: State = .initial
    var mode: Mode = .view {
        didSet {
            switch mode {
            case .view:
                selectBarButton.title = "Select"
                collectionView.allowsMultipleSelection = false
                for (key, value) in dictionarySelectedIndexPath {
                    if value {
                        collectionView.deselectItem(at: key, animated: true)
                    }
                }
                dictionarySelectedIndexPath.removeAll()
                selectedPhotos.removeAll()
                self.navigationItem.leftBarButtonItem?.isEnabled = false
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
            default:
                selectBarButton.title = "Cancel"
                collectionView.allowsMultipleSelection = true
                self.navigationItem.leftBarButtonItem?.isEnabled = true
                self.navigationItem.leftBarButtonItem?.tintColor = UIColor.systemBlue
            }
        }
    }
    let viewModel = ViewModel(apiClient: UnsplashClient())
    let showDetailVCSegue = "ShowImageDetail"
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    var page = 1;
    var isLoading = false
    var loadingView: LoadingReusableView?
    var searchingText: String? = ""
    var dictionarySelectedIndexPath: [IndexPath: Bool] = [:]
    var spinnerView: UIView?
    private var selectedPhotos: [UIImage] = []
    
    
    lazy var selectBarButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(didSelectButtonClicked(_:)))
    }()
    
    lazy var shareBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didShareButtonClicked(_:)))
        return button
    }()
    
    // VC
    var selectedImage: UIImage!
    var id: String!
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        // Delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        // Register Cell
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        self.collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingreusableviewid")
        
        // GridView
        self.setupGridView()
        
        // ViewModel
        self.setupViewModel()
        
        // Text field for search
        setupTextField()
        
        // Bar Button items
        setupBarButtonItems()
    }
    
    func setupTextField() {
        let searchInput = UITextField(frame: CGRect(x: 10.0, y: 100.0, width: UIScreen.main.bounds.size.width - 20.0, height: 50.0))
        
        searchInput.backgroundColor = .white
        searchInput.borderStyle = .roundedRect
//        searchInput.placeholder = "Search photos"
        searchInput.delegate = self
        searchInput.textColor = .black
        self.view.addSubview(searchInput)
    }
    
    func setupViewModel() {
        viewModel.showInfinityLoading = {
            if self.viewModel.isLoading {
                self.isLoading = true
                if (self.state == .initial) {
                    self.showSpinner()
                }
            } else {
                self.isLoading = false
                if (self.state == .initial) {
                    self.state = .normal
                }
                self.removeSpinner()
            }
        }
        
        viewModel.searching = {
            if self.viewModel.isSearching {
                self.showSpinner()
            } else {
                self.removeSpinner()
            }
        }
        
        viewModel.showError = { error in
            print(error)
        }
        
        viewModel.reloadData = {
            self.collectionView.reloadData()
        }
        
        viewModel.fetchPhotos(page: self.page, searching: false, text: "")
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    private func setupBarButtonItems() {
        navigationItem.rightBarButtonItem = selectBarButton
        navigationItem.leftBarButtonItem = shareBarButtonItem
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
    }
    
    private func setStateToSearching() {
        self.state = .searching
        self.page = 1
    }
    
    @objc func didSelectButtonClicked(_ sender: UIBarButtonItem) {
        mode = mode == .view ? .selection : .view
    }
    
    @objc func didShareButtonClicked(_ sender: UIBarButtonItem) {
        guard !dictionarySelectedIndexPath.isEmpty else {
            return
        }
        
        let shareController = UIActivityViewController(activityItems: selectedPhotos, applicationActivities: nil)
        shareController.completionWithItemsHandler = {_,_,_,_ in
            self.selectedPhotos.removeAll()
            self.mode = .view
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    
    func showSpinner() {
        spinnerView = UIView(frame: self.view.bounds)
        spinnerView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.center = spinnerView!.center
        ai.startAnimating()
        spinnerView?.addSubview(ai)
        self.view.addSubview(spinnerView!)
    }
    
    func removeSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }

}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        if (self.isLoading == false) {
            let image = self.viewModel.cellViewModels[indexPath.row].image
            cell.setData(image: image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedImage = self.viewModel.cellViewModels[indexPath.row].image
            id = self.viewModel.cellViewModels[indexPath.row].photoId
            performSegue(withIdentifier: self.showDetailVCSegue, sender: nil)
        case .selection:
            dictionarySelectedIndexPath[indexPath] = true
            self.selectedPhotos.append(self.viewModel.cellViewModels[indexPath.row].image)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if mode == .selection {
            dictionarySelectedIndexPath[indexPath] = false
            let photo = self.viewModel.cellViewModels[indexPath.row].image
            if let index = selectedPhotos.firstIndex(of: photo) {
                selectedPhotos.remove(at: index)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == self.showDetailVCSegue {
            let detailVC = segue.destination as! DetailViewController
            detailVC.id = self.id
            detailVC.image = self.selectedImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingreusableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width)
    }
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(self.estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.cellViewModels.count - 2 && !self.isLoading {
            if !self.isLoading {
                DispatchQueue.global().async {
                    sleep(2)
                    DispatchQueue.main.async {
                        self.page += 1
                        switch self.state {
                        case .normal:
                            self.viewModel.fetchPhotos(page: self.page, searching: false, text: "")
                        case .searching:
                            self.viewModel.fetchPhotos(page: self.page, searching: true, text: self.searchingText)
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
}

extension CollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setStateToSearching()
        self.searchingText = textField.text
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
}

// MARK: PUSH NOTIFICATIONS
extension CollectionViewController {
    func setupUserNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Hey I'm new notification"
        content.body = "Look at me"
        
        let uuid = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuid, content: content, trigger: <#T##UNNotificationTrigger?#>)
    }
}
