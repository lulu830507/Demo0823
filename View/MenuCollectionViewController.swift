//
//  MenuCollectionViewController.swift
//  Demo0823
//
//  Created by 林思甯 on 2021/9/2.
//

import UIKit

private let reuseIdentifier = "MenuCollectionViewCell"

class MenuCollectionViewController: UICollectionViewController {
    
    var menuData = [Menu.Record]()
    let urlStr = "https://api.airtable.com/v0/appVMGKzXjkJyUpow/Menu?sort[][field]=createdtime"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: 192, height: 250)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = 1
        
        
        MenuController.shared.fetchData(urlStr: urlStr) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let menuData):
                    self.updateUI(with: menuData)
                    print("success")
                case .failure(let error):
                    self.displayError(error, title: "Failed")
                }
            }
        }
        
        let barButtonItem = UIBarButtonItem(title: "MENU", style: .plain, target: self, action: nil)
        let image = UIImage(systemName: "arrow.backward")
        navigationItem.backBarButtonItem = barButtonItem
        let barappearance = UINavigationBarAppearance()
        barappearance.setBackIndicatorImage(image, transitionMaskImage: image)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        if let selectedItem = collectionView.indexPath(for: cell)?.row,
           let controller = segue.destination as? OrderTableViewController {
            let menuData = menuData[selectedItem]
            controller.menuData = menuData
        }
    }
    
    
    func updateUI(with menuData:[Menu.Record]) {
        
        self.menuData = menuData
        self.collectionView.reloadData()
    }
    
    func displayError(_ error: Error, title: String) {
        
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menuData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(MenuCollectionViewCell.self)", for: indexPath) as! MenuCollectionViewCell
        
        let menuData = menuData[indexPath.row]
        cell.drinkLabel.text = menuData.fields.name
        let imageURL = menuData.fields.image[0].url
        MenuController.shared.fetchImage(url: imageURL) { image in
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                cell.drinkImageView.image = image
            }
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
