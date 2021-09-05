//
//  OrderList.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation

struct OrderList: Codable {
    
    var records: [Record]
    
    struct Record: Codable {
        var id: String
        var fields: OrderDetail.Field
    }
}
