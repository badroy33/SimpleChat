//
//  UISegmentedControl + Extension.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 28.04.2021.
//

import UIKit

extension UISegmentedControl {
    convenience init(firstElement: String, secondElement: String) {
        self.init()
        self.insertSegment(withTitle: firstElement, at: 0, animated: true)
        self.insertSegment(withTitle: secondElement, at: 1, animated: true)
        self.selectedSegmentIndex = 0
    }
}
