//
//  JokeItemViewCell.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/22/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit

@IBDesignable class JokeItemViewCell: UICollectionViewCell {
    @IBOutlet weak var content: UITextView!
    
    override func prepareForInterfaceBuilder() {
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBInspectable var borderWidth: CGFloat = 6.0 {
        didSet {
            self.layer.borderWidth = self.borderWidth
        }
    }
    
    var itemModel: ItemModel? {
        didSet {
            guard let model = itemModel else { return }
            
            if let unwrappedContent = model.content {
                content.text = unwrappedContent
                hideSkeleton()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        showSkeleton()
    }
}
