//
//  ProductTableViewCell.swift
//  Walmart
//
//  Created by ilyas on 6/26/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var productImageView: UIImageView!
    
    @IBOutlet var productNameLbl: UILabel!
    
    @IBOutlet var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
