//
//  UIButton + Extension.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 26.04.2021.
//

import UIKit

extension UIButton{
    convenience init(title: String,
                     titleColor: UIColor,
                     font: UIFont? = UIFont.avenirNextMedium20(),
                     isShadow: Bool = false,
                     backgroundColor: UIColor,
                     cornerRadius: CGFloat = 5){
    
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 1, height: 3)
        }
    }
    
    func addGoogleImage(){
        let googleImage = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleToFill)
        googleImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleImage)
        NSLayoutConstraint.activate([
            googleImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            googleImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
