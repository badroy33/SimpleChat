//
//  OneLineTextField.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 27.04.2021.
//

import UIKit

class OneLineTextField: UITextField {
    convenience init(font: UIFont? = .avenirNextMedium20(), secureText: Bool = false){
        self.init()

        self.borderStyle = .none
        self.textColor = .black
        self.isSecureTextEntry = secureText
        self.textContentType = .oneTimeCode
        self.translatesAutoresizingMaskIntoConstraints = false
        
        var lineView = UIView()
        lineView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        lineView.backgroundColor = .buttonBackgroungColorPurple()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
    }
}
