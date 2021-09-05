//
//  PickerViewExtension.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/3.
//

import Foundation
import UIKit

extension OrderTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //顯示幾列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //各列有多少行資料
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return Temperature.allCases.count
        case 1:
            return Sweetness.allCases.count
        case 2:
            return Size.allCases.count
        default:
            return Toppings.allCases.count
        }
    }
    //每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return Temperature.allCases[row].rawValue
        case 1:
            return Sweetness.allCases[row].rawValue
        case 2:
            return Size.allCases[row].rawValue
        default:
            return Toppings.allCases[row].rawValue
        }
    }
    //選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerview.tag {
        case 0:
            temp = Temperature.allCases[row].rawValue
        case 1:
            sweetness = Sweetness.allCases[row].rawValue
        case 2:
            size = Size.allCases[row].rawValue
            if row == 0 {
                price = menuData.fields.large
                priceLabel.text = String(price)
            } else {
                price = menuData.fields.medium
                priceLabel.text = String(price)
            }
        default:
            toppings = Toppings.allCases[row].rawValue
            switch row {
            case 1:
                price += 5
                priceLabel.text = String(price)
            case 2:
                price += 5
                priceLabel.text = String(price)
            case 3:
                price += 15
                priceLabel.text = String(price)
            case 4:
                price += 15
                priceLabel.text = String(price)
            case 5:
                price += 15
                priceLabel.text = String(price)
            default:
                break
            }
            if sizeTextField.text == "中杯" {
                price = menuData.fields.medium
                priceLabel.text = String(price)
            } else {
                let large = menuData.fields.large
                price = large
                priceLabel.text = String(price)
            }
        }
    }
}



