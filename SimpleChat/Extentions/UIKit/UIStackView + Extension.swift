//
//  UIStackView + Extension.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 26.04.2021.
//

import UIKit

extension UIStackView{
    convenience init(arrangedSubviews: [UIView],axis: NSLayoutConstraint.Axis, spacing: CGFloat){
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
    }
}
