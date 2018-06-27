//
//  DetailViewController.swift
//  Walmart
//
//  Created by ilyas on 6/26/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!

    var productData: [Product]!
    var isScrollIndex = false
    var index : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarImage()
        
        collectionView.delegate = self
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// this is done to set the index on start to 1 to have at index 0 the last image to have a infinity loop
        if !self.isScrollIndex {
            self.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: false)
            self.isScrollIndex = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! DetailCollectionViewCell
        
        cell.pImageView.loadImageUsingCaches(withUrl:Constants.API_URL + self.productData[indexPath.row].productImage!)
        cell.inStockImageView.image = self.productData[indexPath.row].inStock == false ? UIImage(named: "out_of_stock") : nil

        cell.pProductName.text = self.productData[indexPath.row].productName
        cell.pPriceLabel.text = self.productData[indexPath.row].price
        
        cell.pShortDescription.attributedText = self.productData[indexPath.row].shortDescription?.htmlToAttributedString
        cell.pShortDescription.font = UIFont.systemFont(ofSize: 16.0)
        
        cell.pLongDescription.attributedText = self.productData[indexPath.row].longDescription?.htmlToAttributedString
        cell.pLongDescription.font = UIFont.systemFont(ofSize: 14.0)

        cell.rating = ( reviewRating: self.productData[indexPath.row].reviewRating,
                        reviewCount: self.productData[indexPath.row].reviewCount) 

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func addNavBarImage()
    {
        let imageView = UIImageView(image: UIImage(named: "logo-walmart"))
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 44))
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        
        self.navigationItem.titleView = titleView
    }
}
