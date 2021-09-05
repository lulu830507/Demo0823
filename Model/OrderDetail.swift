//
//  OrderDetail.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation

struct OrderDetail: Codable {
    var records: [Record]
    
    struct Record: Codable {
        var fields: Field
    }

    struct Field: Codable {
        var name: String
        var image: URL
        var drinks: String
        var size: String
        var toppings: String
        var iceLevel: String
        var sugarLevel: String
        var quantity: Int
        var price: Int
    }
}
