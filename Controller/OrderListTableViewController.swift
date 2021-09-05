//
//  OrderListTableViewController.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/3.
//

import UIKit

class OrderListTableViewController: UITableViewController {
    
    var orderList = [OrderList.Record]()
    let urlStr = "https://api.airtable.com/v0/appVMGKzXjkJyUpow/OrderList?sort[][field]=createdTime"

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(tableView!, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdateNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        MenuController.shared.fetchOrderData(urlStr: urlStr) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orderList):
                    self.updateUI(with: orderList)
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    }
    
    func updateUI(with orderList: [OrderList.Record]) {
        DispatchQueue.main.async {
            self.orderList = orderList
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(OrderListTableViewCell.self)", for: indexPath) as! OrderListTableViewCell
        
        let orderDetail = orderList[indexPath.row]
        MenuController.shared.fetchImage(url: orderDetail.fields.image) { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                cell.drinkImageview.image = image
            }
        }
        cell.nameLabel.text = orderDetail.fields.name
        cell.drinkNameLabel.text = orderDetail.fields.drinks
        cell.iceLabel.text = orderDetail.fields.iceLevel
        cell.sugarLabel.text = orderDetail.fields.sugarLevel
        cell.countLabel.text = "\(orderDetail.fields.quantity)杯"
        cell.priceLabel.text = String(orderDetail.fields.price)
        if orderDetail.fields.toppings == "無" {
            cell.toppingsLabel.text = ""
        } else {
            cell.toppingsLabel.text = "+\(orderDetail.fields.toppings)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.deleteOrderData(urlStr: "https://api.airtable.com/v0/appVMGKzXjkJyUpow/OrderList/" + orderList[indexPath.row].id)
            orderList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
