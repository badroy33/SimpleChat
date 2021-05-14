//
//  SelfCellConfiguration.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 05.05.2021.
//

import UIKit

protocol SelfCellConfiguration {
    static var reuseId: String { get }
    func configure<U: Hashable>(with value: U)
}

