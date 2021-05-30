//
//  CurrentChatCell.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 01.05.2021.
//

import UIKit
import SDWebImage

class CurrentChatCell: UICollectionViewCell, SelfCellConfiguration{
    
    static var reuseId: String = "currentChatCell"
    
    var userImageView = UIImageView()
    var userNameLabel = UILabel(text: "User name", font: UIFont.laoSangamMN20())
    var lastMessageLabel = UILabel(text: "Last message", font: UIFont.laoSangamMN18())
    var gradientView = GradientView(from: .topLeading, to: .bottomTrailing, startColor: #colorLiteral(red: 0.6340375543, green: 0.4557526112, blue: 0.7003472447, alpha: 1), endColor: #colorLiteral(red: 0.6505529284, green: 0.6396402717, blue: 0.9341823459, alpha: 1))
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        setUpConstraints()
    }
    
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: ChatModel = value as? ChatModel else { return }
        userImageView.sd_setImage(with: URL(string: chat.friendImageStringURL), completed: nil)
        userNameLabel.text = chat.friendUsername
        lastMessageLabel.text = chat.lastMessageContent
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Setup constraints

extension CurrentChatCell{
    private func setUpConstraints(){
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        userImageView.layer.cornerRadius = 5
        userImageView.clipsToBounds = true
        gradientView.layer.cornerRadius = 5
        gradientView.clipsToBounds = true
        
        
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(lastMessageLabel)
        self.addSubview(gradientView)
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            userImageView.heightAnchor.constraint(equalToConstant: 78),
            userImageView.widthAnchor.constraint(equalToConstant: 78),
            userImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8),
            
            userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
            
            lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            lastMessageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            lastMessageLabel.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16)
            
            
        ])
    }
}



// MARK: - SwiftUI

import SwiftUI

struct CurrentChatCellProvider: PreviewProvider{
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

