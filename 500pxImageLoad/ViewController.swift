//
//  ViewController.swift
//  500pxImageLoad
//
//  Created by Darren Leak on 2017/07/07.
//  Copyright © 2017 Darren Leak. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, DataTaskRunnable {
    var imageURLArray = [String]()
    var imageCache = NSCache<AnyObject, AnyObject>()
    var currentPage = 0
    var totalPages = 0

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCells()
        self.activityLoader()
        self.getImages(.photos)
    }
    
    func getImages(_ endpoint: APIEndpoint) {
        dataForApiEndpoint(endpoint) { (responseData, error) in
            if error == nil
            {
                if let data = responseData
                {
                    self.pageInformation(pageInfo: DataProcessor.pageInformationFromData(data))
                    let processedData = DataProcessor.imageUrlsFromData(data)
                    
                    if (processedData.error == nil)
                    {
                        OperationQueue.main.addOperation {
                            self.imageURLArray.append(contentsOf: processedData.imageUrlStrings)
                            self.activityLoader()
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
            else
            {
                if let unwrappedError = error
                {
                    print("Error: \(unwrappedError.localizedDescription)")
                }
            }
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellIdentifier", for: indexPath) as? ImageCell
        {
            cell.imageView.image = nil
            
            if let imageCacheImage = self.imageCache.object(forKey: self.imageURLArray[indexPath.item] as AnyObject) as? UIImage
            {
                cell.imageView.image = imageCacheImage
            }
            else
            {
                let imageStringURL = self.imageURLArray[indexPath.item]
                dataForImageURLString(imageStringURL, order: indexPath.item, completion: { (image, error) in
                    if error == nil
                    {
                        OperationQueue.main.addOperation {
                            if let returnedImage = image
                            {
                                self.imageCache.setObject(returnedImage, forKey: self.imageURLArray[indexPath.item] as AnyObject)
                                if let imageCacheImage = self.imageCache.object(forKey: self.imageURLArray[indexPath.item] as AnyObject) as? UIImage
                                {
                                    cell.imageView.image = imageCacheImage
                                }
                            }
                        }
                    }
                })
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.item == self.imageURLArray.count - 1)
        {
            self.nextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10.0
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        {
            let sideSpacing = indexPath.item % 2 == 0 ? spacing / 4 : spacing
            flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                                   left: sideSpacing,
                                                   bottom: 0,
                                                   right: sideSpacing)
        }
        
        var collectionViewSize = collectionView.frame.size
        collectionViewSize.width = (collectionViewSize.width / 2.0) - spacing
        collectionViewSize.height = collectionViewSize.width
        
        return collectionViewSize
    }
    
    // register collectionview cells
    func registerCells()
    {
        let cellNib = UINib(nibName: "ImageCell", bundle: Bundle.main)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "ImageCellIdentifier")
    }
    
    
    func pageInformation(pageInfo: (currentPage: Int, totalPages: Int))
    {
        self.currentPage = pageInfo.currentPage
        self.totalPages = pageInfo.totalPages
    }
    
    func nextPage()
    {
        let nextPage = self.currentPage + 1
        if nextPage < self.totalPages
        {
            self.getImages(.page(pageNumber: nextPage, endpoint: APIEndpoint.photos.stringValue()))
        }
    }
    
    func activityLoader()
    {
        if self.activityIndicator.isAnimating
        {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        else
        {
            self.activityIndicator.startAnimating()
        }
    }
}
