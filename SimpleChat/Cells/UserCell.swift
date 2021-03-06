//
//  UserCell.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 08.05.2021.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell, SelfCellConfiguration {
    
    static var reuseId: String = "UserCell"
    
    let userImageView = UIImageView()
    let userNameLabel = UILabel(text: "text", font: UIFont.laoSangamMN20(), textColor: UIColor.buttonDarkTextColor())
    let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setUpConstraints()
        
        self.layer.cornerRadius = 5
        
        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 5
        self.containerView.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        userImageView.image = nil
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let user: UserModel = value as? UserModel else { return }
        self.userNameLabel.text = user.username
        guard let url = URL(string: user.avatarStringURL) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
        userImageView.contentMode = .scaleAspectFill
        userImageView.clipsToBounds = true
    }
    
    private func setUpConstraints() {
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(userImageView)
        containerView.addSubview(userNameLabel)
        
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            
            userNameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            userNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)  
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SwiftUI

import SwiftUI

struct UserCellProvider: PreviewProvider {
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
