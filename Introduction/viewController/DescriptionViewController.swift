//
//  DescriptionViewController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/17/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit
import SkeletonView

protocol DescriptionViewControllerDelegate {
    func deleteItem(item: ItemModel)
    func changeItem(newItem: ItemModel)
}

class DescriptionViewController: UIViewController {
    @IBOutlet weak var itemContentPreview: UILabel!
    @IBOutlet weak var itemContentEdit: UITextView!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    var itemModel: ItemModel? = nil
    var delegate: DescriptionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.action = #selector(closeController)
        closeButton.target = self
        
        itemContentPreview.text = itemModel?.content
        deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
    }
    
    @objc func changeButtonClicked() {
        changeEditMode(enable: itemContentPreview.isHidden)
    }

    @objc func deleteButtonClicked(){
        if (itemModel != nil){
            delegate?.deleteItem(item: itemModel!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func closeController() {
        self.dismiss(animated: true, completion: nil)
    }
}

// Edit modes manipulation
extension DescriptionViewController {
    func changeEditMode(enable: Bool){
        
    }
}
