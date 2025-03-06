//
//  Product.swift
//  AssignmentStuck
//
//  Created by Sambhav Singh on 06/03/25.
//

import Foundation

struct Product: Identifiable, Codable {
    let id = UUID()
    let image: String
    let price: Double
    let productName: String
    let productType: String
    let tax: Double
    
    enum CodingKeys: String, CodingKey {
        case image
        case price
        case productName = "product_name"
        case productType = "product_type"
        case tax
    }
}
