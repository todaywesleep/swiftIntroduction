//
//  StackViewController.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/22/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var requestButton: UIButton!
    
    var delegate: RequestProtocol?
    var data:[ItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = true
        stackView.axis = .vertical
        stackView.spacing = 54
        stackView.distribution = .fill
        
        requestButton.addTarget(self, action: #selector(onRequestPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initItemsCollection()
    }
    
    @objc func onRequestPressed(){
        delegate?.requestNewJoke()
    }
    
    func initItemsCollection(){
        for view in self.stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for item in data {
            self.stackView.addArrangedSubview(createItemView(item))
        }
    }
    
    func createItemView(_ item: ItemModel) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 54))
        let label = UILabel()
        
        label.numberOfLines = 0
        label.frame = view.frame
        label.text = item.content
        label.textColor = UIColor.black
        
        view.heightAnchor.constraint(equalToConstant: 8).isActive = true
        view.accessibilityIdentifier = item.content
        view.addSubview(label)
        
        return view
    }
    
    func getViewFromItem(_ item: ItemModel) -> UIView? {
        for view in stackView.arrangedSubviews {
            if view.accessibilityIdentifier == item.content{
                return view
            }
        }
        
        return nil
    }
    
    func onItemAddedToDatabase(_ itemModel: ItemModel) {
        self.data.insert(itemModel, at: 0)
        initItemsCollection()
    }
    
    func onItemDeletedFromDatabase(_ itemModel: ItemModel) {
        if let idx = data.firstIndex(where: { $0 === itemModel }) {
            data.remove(at: idx)
        }
    }
}
