//
//  TextFieldExtension.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/3.
//

import Foundation
import UIKit

extension OrderTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setPickerView(selectedAt: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
}
