//
//  UILable + Extension.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 26.04.2021.
//

import UIKit

extension UILabel{
    convenience init(text: String, font: UIFont? = UIFont.avenirNextMedium18(), textColor: UIColor = UIColor.buttonDarkTextColor()){
        self.init()
        self.text = text
        self.font = font
        self.textColor = textColor
    }
}
