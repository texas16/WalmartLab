//
//  Constants.swift
//  Walmart
//
//  Created by ilyas on 6/27/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import Foundation

//URL to make Api Calls
//https://mobile-tha-server.appspot.com

//Get Products List
///walmartproducts/{pageNumber}/{pageSize}

//Input Parameters
//pageNumber - (Required) Page Number of the list of products - Starts from 1
//pageSize - (Required) Number of products to be returned in a page - Maximum is 30

struct Constants {
    static let API_URL = "https://mobile-tha-server.appspot.com"
    static let PATH = "walmartproducts"
    static let IMAGE_PATH_URL = "https://mobile-tha-server.appspot.com"
    static let PAGE_SIZE = "20"
    static let REVIEW_BASED_ON = 5
}
