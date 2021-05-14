//
//  AddPhotoView.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 28.04.2021.
//

import UIKit

class AddPhotoView: UIView{
    var avatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "avatar")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "plus")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.black
        return button
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImage)
        addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 100),
            avatarImage.widthAnchor.constraint(equalToConstant: 100),
            avatarImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            avatarImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            plusButton.leadingAnchor.constraint(equalTo: avatarImage.trailingAnchor, constant: 15),
            plusButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            
            self.bottomAnchor.constraint(equalTo: avatarImage.bottomAnchor),
            self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImage.layer.masksToBounds = true
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
