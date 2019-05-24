//
//  TableViewController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/15/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import SkeletonView
import UIKit
import Alamofire
import Reachability

// Base class methods
class TableViewController: UIViewController {
    // Outlets / Actions
    @IBOutlet weak var tableView: UITableView!
    
    // Const section
    let reachability = Reachability()!
    let alert: UIAlertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    
    // Variables section
    var isDeviceOnline = false
    var data: [ItemModel] = []
    var delegate: RequestProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initChildViews()
        
        self.setReachabilityListener()
        self.startReachabilityNotifier()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
//        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func initChildViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
    }
    
    @objc func addItemToCollection(){
        let itemModel = ItemModel()
        itemModel.content = nil
        itemModel.idx = -1
        
        self.data.insert(itemModel, at: 0)
        self.tableView.insertRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
        
        delegate?.requestNewJoke()
    }
    
    func onItemAddedToDatabase(_ itemModel: ItemModel) {
        if let idx = self.data.firstIndex(where: { $0.idx == -1 }) {
            self.data[idx] = itemModel
            self.tableView.reloadRows(at: [IndexPath(item: idx, section: 1)], with: .fade)
        } else {
            self.data.insert(itemModel, at: 0)
        }
    }
    
    func onItemDeletedFromDatabase(_ itemModel: ItemModel) {
//        if let idx = data.firstIndex(where: { $0 === itemModel }) {
//            data.remove(at: idx)
//        }
    }
}

// Description delegate realization
extension TableViewController: DescriptionViewControllerDelegate {
    func deleteItem(item: ItemModel) {
        if let idx = data.firstIndex(where: { $0 === item }) {
            delegate?.requestDeleteJoke(item)
            data.remove(at: idx)
            tableView.deleteRows(at: [IndexPath(item: idx, section: 1)], with: .automatic)
        }
    }
    
    func changeItem(newItem: ItemModel) {
        
    }
}

// Table delegates
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch indexPath.section {
        case 0:
            return .none
        default:
            return [UITableViewRowAction(style: .destructive, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath: IndexPath) -> Void in
                if let idx = self.data.firstIndex(where: { $0 === self.data[indexPath.row] }) {
                    self.delegate?.requestDeleteJoke(self.data[indexPath.row])
                    
                    self.data.remove(at: idx)
                    self.tableView.deleteRows(at: [IndexPath(item: idx, section: 1)], with: .automatic)
                }
            })]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let castedCell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
            
            if let requestButtonUnwrapped = castedCell.requestButton {
                requestButtonUnwrapped.addTarget(self, action: #selector(addItemToCollection), for: .touchUpInside)
                requestButtonUnwrapped.setState(isEnabled: isDeviceOnline)
            }
            
            return castedCell
        default:
            let castedCell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! ItemViewCell
            let item = data[indexPath.row]
            castedCell.itemModel = item
            return castedCell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let senderObj = sender as? ItemViewCell {
            if let dest = segue.destination as? DescriptionViewController {
                dest.itemModel = senderObj.itemModel
                dest.delegate = self
            }
        }
    }
}

// Reachability controller
extension TableViewController {
    private func startReachabilityNotifier() {
        do {
            try self.reachability.startNotifier()
            print("Notifier started")
        } catch {
            print("Unable to start notifier")
        }
    }
    
    private func setReachabilityListener(){
        reachability.whenReachable = { reachability in
            self.isDeviceOnline = true
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        }
        
        reachability.whenUnreachable = { _ in
            self.isDeviceOnline = false
            self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .fade)
        }
    }
}
