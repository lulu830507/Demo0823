//
//  OrderTableViewController.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/2.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    let urlStr = "https://api.airtable.com/v0/appVMGKzXjkJyUpow/OrderList"
    var menuData: Menu.Record!
    var orderDeatil = [OrderDetail.Record]()
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkNameLabel: UILabel!
    @IBOutlet weak var drinkDescription: UILabel!
    @IBOutlet weak var orderNameTextField: UITextField!
    @IBOutlet weak var iceLevelTextField: UITextField!
    @IBOutlet weak var sugarLevelTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var toppingsTextField: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    let pickerview = UIPickerView()
    var temp = String()
    var sweetness = String()
    var size = String()
    var toppings = String()
    var quantity = 1
    var price = Int()
    var orderName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drinkNameLabel.text = menuData.fields.name
        drinkDescription.text = menuData.fields.description
        let imageURL = menuData.fields.image[0].url
        orderButton.layer.cornerRadius = 10
        
        MenuController.shared.fetchImage(url: imageURL) { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.drinkImage.image = image
            }
        }
        
        orderNameTextField.delegate = self
        iceLevelTextField.delegate = self
        sugarLevelTextField.delegate = self
        sizeTextField.delegate = self
        toppingsTextField.delegate = self
        quantityLabel.text = String(quantity)
        priceLabel.text = String(price)
        tapGesture()
        
    }
    
    func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
    func setPickerView(selectedAt sender: UITextField) {
        
        switch sender {
        case iceLevelTextField:
            pickerview.tag = 0
        case sugarLevelTextField:
            pickerview.tag = 1
        case sizeTextField:
            pickerview.tag = 2
        case toppingsTextField:
            pickerview.tag = 3
        default:
            break
        }
        
        pickerview.delegate = self
        pickerview.dataSource = self
        
        //設定PickerView的ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        iceLevelTextField.inputView = pickerview
        sugarLevelTextField.inputView = pickerview
        sizeTextField.inputView = pickerview
        toppingsTextField.inputView = pickerview
        
        iceLevelTextField.inputAccessoryView = toolBar
        sugarLevelTextField.inputAccessoryView = toolBar
        sizeTextField.inputAccessoryView = toolBar
        toppingsTextField.inputAccessoryView = toolBar
    }
    
    @objc func done() {
        if let orderName = orderNameTextField.text{
            self.orderName = orderName
        }
        
        switch pickerview.tag {
        case 0:
            iceLevelTextField.text = temp
            if temp.isEmpty == true {
                temp = Temperature.allCases[0].rawValue
                iceLevelTextField.text = temp
            }
        case 1:
            sugarLevelTextField.text = sweetness
            if sweetness.isEmpty == true {
                sweetness = Sweetness.allCases[0].rawValue
                sugarLevelTextField.text = sweetness
            }
        case 2:
            sizeTextField.text = size
            if size.isEmpty == true {
                size = Size.allCases[0].rawValue
                sizeTextField.text = size
                price = menuData.fields.medium
                priceLabel.text = String(price)
            }
            sizeTextField.resignFirstResponder()
        default:
            toppingsTextField.text = toppings
            if toppings.isEmpty == true {
                toppings = Toppings.allCases[0].rawValue
                toppingsTextField.text = toppings
            }
            toppingsTextField.resignFirstResponder()
        }
    }
    
    @objc func cancel() {
        iceLevelTextField.resignFirstResponder()
        sugarLevelTextField.resignFirstResponder()
        sizeTextField.resignFirstResponder()
    }
    
    func updateUI(with orderDetail: [OrderDetail.Record]) {
        DispatchQueue.main.async { [self] in
            self.orderDeatil = orderDeatil
        }
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if quantity <= 1 {
            let alert = UIAlertController(title: "錯誤", message: "請輸入1杯以上", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            quantity -= 1
            quantityLabel.text = String(quantity)
            priceLabel.text = String(price * quantity)
        }
    }
    
    @IBAction func plusButton(_ sender: Any) {
        quantity += 1
        quantityLabel.text = String(quantity)
        priceLabel.text = String(price * quantity)
    }
    
    @IBAction func submetButton(_ sender: Any) {
        let fielData = OrderDetail.Field(name: orderName, image: menuData.fields.image[0].url, drinks: menuData.fields.name, size: size, toppings: toppings, iceLevel: temp, sugarLevel: sweetness, quantity: quantity, price: price)
        let recordData = OrderDetail.Record(fields: fielData)
        let orderDetailData = OrderDetail(records: [recordData])
        //檢查是否有沒輸入的項目
        if orderNameTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請輸入訂購人名字")
        } else if iceLevelTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇飲品溫度")
        } else if sugarLevelTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇飲品甜度")
        } else if sizeTextField.text?.isEmpty == true {
            showAlert(title: "警告！", message: "請選擇是否加料")
        } else {
            confirmOrder { _ in MenuController.shared.uploadData(urlStr: self.urlStr, data: orderDetailData)
                MenuController.shared.order.orders.append(recordData)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //錯誤跳警告視窗
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //飲料加入訂單跳確認視窗
        func confirmOrder(action: @escaping (UIAlertAction) -> Void) {
            let alert = UIAlertController(title: "確認加入訂購清單嗎？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "確認", style: .default, handler: action))
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
