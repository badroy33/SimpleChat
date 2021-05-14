//
//  ProfileViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 11.05.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "human3"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Rob Shnider", font: .systemFont(ofSize: 20, weight: .light),textColor: .black)
    let aboutMeLabel = UILabel(text: "I'm the real man. Germans hi hitler see you in hell.", font: .systemFont(ofSize: 18, weight: .light), textColor: UIColor.buttonDarkTextColor())
    let textField = InsertableTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpConstraints()
    }
    
}


extension ProfileViewController{
    private func setUpConstraints(){
        editElements()
        containerView.addSubview(nameLabel)
        containerView.addSubview(aboutMeLabel)
        containerView.addSubview(textField)
        
        view.addSubview(profileImageView)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  30),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 240),
            
            profileImageView.topAnchor.constraint(equalTo: view.topAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            
            aboutMeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            aboutMeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            aboutMeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            
            textField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 15),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            textField.heightAnchor.constraint(equalToConstant: 48)
            
        ])
    }
    
    private func editElements(){
        containerView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
         
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhiteColor()
        aboutMeLabel.numberOfLines = 0
        
        if let button = textField.rightView as? UIButton{
            button.addTarget(self, action: #selector(sendMessege), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessege(){
        print(#function)
    }
}


// MARK: - SwiftUI

import SwiftUI

struct ProfileVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let profileVC = ProfileViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return profileVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}

