//
//  WalmartProducts.swift
//  Walmart
//
//  Created by ilyas on 6/27/18.
//  Copyright © 2018 ilyas. All rights reserved.
//

import Foundation

struct WalmartProducts: Decodable {
    let totalProducts: Int?
    let pageNumber: Int?
    let pageSize: Int?
    let statusCode: Int
    var products: [Product]
}

struct Product: Decodable {
    let productId: String?
    let productName: String?
    let shortDescription: String?
    let longDescription: String?
    let price: String?
    let productImage: String?
    let reviewRating: Float
    let reviewCount: Int
    let inStock: Bool?
}
