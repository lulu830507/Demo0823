//
//  MeunController.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/1.
//

import Foundation
import UIKit

public let apiKey = "key9zB4DuzreL0bYP"

class MenuController {
    
    static let shared = MenuController()
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdate")
    
    
    
    var order = Order() {
        
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    // get menu data
    func fetchData(urlStr: String, completion: @escaping (Result<[Menu.Record], Error>) -> Void) {
        
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data,
               let content = String(data: data, encoding: .utf8) {
                //print(content)
                do {
                    let decoder = JSONDecoder()
                    let menuResponse = try decoder.decode(Menu.self, from: data)
                    completion( .success(menuResponse.records))
                } catch {
                    print(error)
                    completion( .failure(error))
                }
            }
        }.resume()
    }
    
    // get image
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    // upload to airtable
    func uploadData(urlStr: String, data: OrderDetail) {
        
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try? encoder.encode(data)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let response = response as? HTTPURLResponse,
               let content = String(data: data, encoding: .utf8){
                do {
                    print(response.statusCode)
                    //print(content)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    // get data
    func fetchOrderData(urlStr: String, completion: @escaping (Result<[OrderList.Record], Error>) -> Void) {
        let url = URL(string: urlStr)
        //print("URL",url)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                //print("TEST",String(data: data, encoding: .utf8))
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OrderList.self, from: data)
                    completion( .success(response.records))
                } catch {
                    completion( .failure(error))
                }
            } else if let error = error {
                completion( .failure(error))
            }
        }.resume()
    }
    // delete data
    func deleteOrderData(urlStr: String) {
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse,
               error == nil {
                print("Delete success")
                print(response.statusCode)
            } else {
                print(error)
            }
        }.resume()
    }
    
}
