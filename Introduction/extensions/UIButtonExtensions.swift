//
//  UIButtonExtensions.swift
//  Introduction
//
//  Created by Vladislav Erchik on 5/21/19.
//  Copyright © 2019 Vladislav Erchik. All rights reserved.
//

import UIKit
import Foundation

extension UIButton {
    func setState(isEnabled: Bool){
        self.alpha = isEnabled ? 1 : 0.25
        self.isEnabled = isEnabled
    }
}
