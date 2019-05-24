//
//  ButtonCell.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/15/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell {
    @IBOutlet weak var requestButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
