//
//  ProfileViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 11.05.2021.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    let containerView = UIView()
    var profileImageView = UIImageView(image: #imageLiteral(resourceName: "human3"), contentMode: .scaleAspectFill)
    var nameLabel = UILabel(text: "Jack White", font: .systemFont(ofSize: 20, weight: .light),textColor: .black)
    var aboutMeLabel = UILabel(text: "Hello, i like joking.", font: .systemFont(ofSize: 18, weight: .light), textColor: UIColor.buttonDarkTextColor())
    let textField = InsertableTextField()
    
    private let user: UserModel
    
    init(user: UserModel = UserModel(username: "username", email: "email", avatarStringURL: "avatarStringURL", description: "description", sex: "sex", id: "id")) {
        self.user = user
        self.profileImageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
        self.nameLabel.text = user.username
        self.aboutMeLabel.text = user.description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setUpConstraints()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}


extension ProfileViewController {
    private func setUpConstraints() {
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
    
    private func editElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
         
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhiteColor()
        aboutMeLabel.numberOfLines = 0
        
        if let button = textField.rightView as? UIButton{
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    @objc private func sendMessage() {
        guard let message = textField.text, message != "" else { return }
        self.dismiss(animated: true) {
            FirestoreService.shared.createWaitingChat(message: message, reciver: self.user) { (result) in
                switch result{
                case .success():
                    UIApplication.getTopViewController()?.showAlert(with: "Succes", message: "Your message and chat request for \(self.user.username) has been sended")
                case .failure(let error):
                    UIApplication.getTopViewController()?.showAlert(with: "Error", message: error.localizedDescription)
                }
            }
        }
    }
}


// MARK: - SwiftUI

import SwiftUI

struct ProfileVCProvider: PreviewProvider {
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

