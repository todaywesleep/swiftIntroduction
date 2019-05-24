//
//  CollectionViewController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/22/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var requestButton: UIButton!

    weak var delegate: RequestProtocol?
    var data:[ItemModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        requestButton.addTarget(self, action: #selector(onRequestClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
        self.collectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }
    
    @objc func onRequestClicked() {
        let itemModel = ItemModel()
        itemModel.content = nil
        itemModel.idx = -1
        
        self.data.insert(itemModel, at: 0)
        self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])

        delegate?.requestNewJoke()
    }
    
    func onItemAddedToDatabase(_ itemModel: ItemModel) {
        if let idx = self.data.firstIndex(where: { $0.idx == -1 }) {
            self.data[idx] = itemModel
            if self.collectionView != nil {
                self.collectionView.reloadItems(at: [IndexPath(item: idx, section: 0)])
            }
        } else {
            self.data.insert(itemModel, at: 0)
        }
    }
}

extension CollectionViewController {
    func onItemDeletedFromDatabase(_ itemModel: ItemModel) {
        if let idx = data.firstIndex(where: { $0 === itemModel }) {
            data.remove(at: idx)
        }
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "jokeCellCollection", for: indexPath) as! JokeItemViewCell
        
        cell.itemModel = data[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

// Description delegate realization
extension CollectionViewController: DescriptionViewControllerDelegate {
    func deleteItem(item: ItemModel) {
        if let idx = data.firstIndex(where: { $0 === item }) {
            delegate?.requestDeleteJoke(item)
            data.remove(at: idx)
            collectionView.deleteItems(at: [IndexPath(item: idx, section: 1)])
        }
    }
    
    func changeItem(newItem: ItemModel) {
        
    }
}
