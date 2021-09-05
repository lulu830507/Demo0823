//
//  CustomItem.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation

enum Temperature: String, CaseIterable {
    case regular = "正常"
    case less = "少冰"
    case quater = "微冰"
    case none = "去冰"
    case lukewarm = "溫"
    case warm = "溫熱"
    case hot = "熱"
}

enum Sweetness: String, CaseIterable {
    case sugarFree = "無糖"
    case minSugar = "微微糖"
    case quarterSugar = "微糖"
    case halfSugar = "半糖"
    case lessSugar = "少糖"
    case regularSugar = "全糖"
}

enum Size: String, CaseIterable {
    case large = "大杯"
    case medium = "中杯"
}

enum Toppings: String, CaseIterable {
    case none = "無"
    case pearl = "珍珠"
    case ratNoodles = "粉條"
    case pudding = "布丁"
    case redBean = "紅豆"
    case greenTeaJelly = "翡翠凍"
    case oat = "燕麥"
    
}
