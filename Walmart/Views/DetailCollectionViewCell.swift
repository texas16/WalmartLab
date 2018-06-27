//
//  DetailCollectionViewCell.swift
//  Wallmart
//
//  Created by ilyas on 6/27/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pImageView: UIImageView!
    @IBOutlet var pProductName: UILabel!
    @IBOutlet var pShortDescription: UILabel!
    @IBOutlet var pPriceLabel: UILabel!
    @IBOutlet var pLongDescription: UILabel!
    @IBOutlet var inStockImageView: UIImageView!
    @IBOutlet var ratingView: UIStackView!
    
    // keep rewiewRating and reviewCount as Tuple to handle together as an object to put together in the UIStackView
    var rating : (reviewRating: Float?, reviewCount:Int?)
    {
        didSet {
            self.ratingView.addArrangedSubview(addRating(rating: self.rating ))
        }
    }
    
    // Forming rate and rate count with UIStackView
    // Revisit - it can be done in better approach
    func addRating(rating : (reviewRating:Float?, reviewCount:Int?)) -> UIStackView
    {
        self.ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
        if self.rating.reviewRating! > Float(0.0)
        {
            let oneStarImage = UIImage(named: "full")
            let halfStarImage = UIImage(named: "half")
            let emptyStarImage = UIImage(named: "empty")
            
            var value = rating.reviewRating
            
            while true {
                value! -= Float(1.0)
                if value! >= Float(0.0) {
                    print("Add 1 star")
                    
                    let imageView = UIImageView()
                    imageView.image = oneStarImage
                    
                    stackView.addArrangedSubview(imageView)
                } else if value! > Float(-1.0) {
                    print("Add half a star")
                    
                    let imageView = UIImageView()
                    imageView.image = halfStarImage
                    
                    stackView.addArrangedSubview(imageView)
                    break
                }
                else {
                    break
                }
            }
            
            var cnt  = Constants.REVIEW_BASED_ON - stackView.arrangedSubviews.count

            while true {
                cnt -= 1
                if cnt >= 0 {
                    print("Add empty star")
                    
                    let imageView = UIImageView()
                    imageView.image = emptyStarImage
                    stackView.addArrangedSubview(imageView)
                }
                else {
                    break
                }
            }
            
            let ratingCountLbl = UILabel()
            ratingCountLbl.text = "  ( \(rating.reviewCount!) )"
            stackView.addArrangedSubview(ratingCountLbl)
        }
        return stackView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: (NSCoder!)) {
        super.init(coder: aDecoder)!
    }
}
