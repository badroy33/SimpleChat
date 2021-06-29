//
//  AboutMeViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 27.06.2021.
//

import Foundation
import UIKit
import SDWebImage

class AboutMeViewController: UIViewController {
    
    private var currentUser: UserModel = UserModel(username: "", email: "", avatarStringURL: "", description: "", sex: "", id: "")
    let containerView = UIView()
    let imageView = UIImageView()
    let nameLabel = UILabel(text: "", font: .avenirNextMedium20(), textColor: .black)
    let aboutMeLabel = UILabel(text: "", font: .avenirNextMedium18(), textColor: .buttonDarkTextColor())
    
    init(currentUser: UserModel) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        imageView.sd_setImage(with: URL(string: self.currentUser.avatarStringURL), completed: nil)
        nameLabel.text = currentUser.username
        aboutMeLabel.text = currentUser.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .mainWhiteColor()

        self.setUpConstraints()
    }
    
}


// MARK: - setUpConstraints()

extension AboutMeViewController {
    private func editElements(){
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        containerView.backgroundColor = .mainWhiteColor()
        containerView.layer.cornerRadius = 30
        
        
        
    }
    func setUpConstraints(){
        editElements()
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, aboutMeLabel], axis: .vertical, spacing: 30)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        view.addSubview(imageView)
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -25),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -30),
            imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
            containerView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
    }
}


// MARK: - SwiftUI

//import SwiftUI
//
//struct AboutMeVCProvider: PreviewProvider {
//    static var previews: some View {
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//
//    struct ContainerView: UIViewControllerRepresentable {
//        let aboutMeVC = AboutMeViewController()
//
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return aboutMeVC
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
