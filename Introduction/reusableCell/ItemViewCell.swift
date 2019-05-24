//
//  ItemViewCell.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/15/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit
import SkeletonView

class ItemViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    
    var itemModel: ItemModel? {
        didSet {
            guard let model = itemModel else { return }
            
            if let unwrappedContent = model.content {
                title.text = unwrappedContent
                hideSkeleton()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        title.text = nil
        showAnimatedSkeleton()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
