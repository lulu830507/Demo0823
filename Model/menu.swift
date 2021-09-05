//
//  menu.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation

struct Menu: Codable{
    
    let records: [Record]
    
    struct Record: Codable {
        
        let id: String
        let fields: Field
        
        struct Field: Codable {
            
            let name: String
            let image: [ImageData]
            let medium: Int
            let large: Int
            let description: String?
            
            struct ImageData: Codable {
                let url: URL
            }
        }
    }
}
