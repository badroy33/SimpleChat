//
//  WaitingChatCell.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 05.05.2021.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, SelfCellConfiguration {

    
    static let reuseId = "WaitingChatCell"
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUpConstraints()
    }
    
    func configure<U>(with value: U) where U : Hashable {
        guard let chat: ChatModel = value as? ChatModel else { return }
        self.imageView.sd_setImage(with: URL(string: chat.friendImageStringURL), completed: nil)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension WaitingChatCell {
    private func setUpConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
    }
}

// MARK: - SwiftUI

import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
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
