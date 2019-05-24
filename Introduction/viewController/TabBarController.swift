//
//  TabBarController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/22/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit

//
//  TabBarController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/14/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit
import Alamofire

protocol RequestProtocol: class {
    func requestNewJoke()
    func requestDeleteJoke(_ itemModel: ItemModel)
}

class TabController: UITabBarController {
    weak var tableViewController: TableViewController!
    weak var collectionViewController: CollectionViewController!
    weak var stackViewController: StackViewController!
    
    var data:[ItemModel] = RealmHelper.sharedInstance.getAllWrites()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewControllers()
        
        tableViewController.delegate = self
        collectionViewController.delegate = self
        stackViewController.delegate = self
        
        tableViewController.data = self.data
        collectionViewController.data = self.data
        stackViewController.data = self.data
    }
    
    func initViewControllers(){
        if !self.children.isEmpty {
            let viewControllers:[UIViewController] = self.children
            for viewController in viewControllers {
                if viewController is TableViewController {
                    tableViewController = (viewController as! TableViewController)
                } else if viewController is CollectionViewController {
                    collectionViewController = (viewController as! CollectionViewController)
                } else if viewController is StackViewController {
                    stackViewController = (viewController as! StackViewController)
                }
            }
        }
    }
}

// Request protocol realization
extension TabController: RequestProtocol {
    func requestNewJoke() {
        AF.request("https://api.chucknorris.io/jokes/random").responseJSON { response in
            switch response.result {
            case .success(let json):
                let res = (json as! NSDictionary)["value"] as! String?
                
                let itemModel = ItemModel()
                itemModel.content = res ?? "Error getting response"
                itemModel.idx = itemModel.hash
                
                self.writeObjectToDatabase(itemModel)
                self.onItemAddedToDatabase(itemModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestDeleteJoke(_ itemModel: ItemModel) {
        RealmHelper.sharedInstance.deleteItemWrite(item: itemModel)
        
        tableViewController.onItemDeletedFromDatabase(itemModel)
        collectionViewController.onItemDeletedFromDatabase(itemModel)
        stackViewController.onItemDeletedFromDatabase(itemModel)
    }
}

// Child controllers manipulation
extension TabController {
    func onItemAddedToDatabase(_ itemModel: ItemModel){
        tableViewController.onItemAddedToDatabase(itemModel)
        collectionViewController.onItemAddedToDatabase(itemModel)
        stackViewController.onItemAddedToDatabase(itemModel)
    }
    
    func writeObjectToDatabase(_ itemToWrite: ItemModel) {
        RealmHelper.sharedInstance.createItemWrite(item: itemToWrite)
    }
}
