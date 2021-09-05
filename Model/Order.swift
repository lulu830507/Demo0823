//
//  Order.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation

struct Order: Codable {
    
    var orders: [OrderDetail.Record]
    
    init(orders: [OrderDetail.Record] = []) {
        self.orders = orders
    }
}
