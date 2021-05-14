//
//  ButtonsViews.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 26.04.2021.
//

import Foundation
import UIKit

class ButtonsViews: UIView{
    init(label: UILabel, button: UIButton) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(label)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([label.topAnchor.constraint(equalTo: self.topAnchor),
                                     label.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                                     button.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                                     button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
                                     button.heightAnchor.constraint(equalToConstant: 55)
        ])
        
        self.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
