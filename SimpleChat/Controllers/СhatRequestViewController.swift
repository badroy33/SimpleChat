//
//  СhatRequestViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 13.05.2021.
//

import UIKit
import SDWebImage

class ChatRequestViewController: UIViewController {
    
    let containerView = UIView()
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "human4"), contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "", font: .systemFont(ofSize: 20, weight: .light),textColor: .black)
    let acceptMessageLabel = UILabel(text: "You can accept a new conversation.", font: .systemFont(ofSize: 18, weight: .light), textColor: UIColor.buttonDarkTextColor())
    let acceptButton = UIButton(title: "Accept", titleColor: .white, font: .laoSangamMN20(), backgroundColor: .red, cornerRadius: 10)
    let denyButton = UIButton(title: "Deny", titleColor: #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1), font: .laoSangamMN20(), backgroundColor: .white, cornerRadius: 10)
    
    private let chat: ChatModel
    
    weak var delegate: WaitingChatsNavigation?
    
    init(chat: ChatModel) {
        self.chat = chat
        nameLabel.text = chat.friendUsername
        profileImageView.sd_setImage(with: URL(string: chat.friendImageStringURL), completed: nil)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        
        denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
    }
    
    @objc func denyButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
    
    @objc func acceptButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.changeToCurrent(chat: self.chat)
        }
        
        
    }


}


// MARK: -  setUpConstraints(), editElements()

extension ChatRequestViewController {
    
    private func editElements() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        acceptMessageLabel.translatesAutoresizingMaskIntoConstraints = false
         
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = .mainWhiteColor()
        
        acceptMessageLabel.numberOfLines = 0
    
        denyButton.layer.borderWidth = 1.2
        denyButton.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.2, blue: 0.2, alpha: 1)
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.acceptButton.applyGradients(cornerRadius: 10)
    }
    
    
    private func setUpConstraints() {
        
        
        let stackView = UIStackView(arrangedSubviews: [acceptButton, denyButton], axis: .horizontal, spacing: 8)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = UIStackView.Distribution.fillEqually
        containerView.addSubview(nameLabel)
        containerView.addSubview(acceptMessageLabel)
        containerView.addSubview(stackView)
        

        view.addSubview(profileImageView)
        view.addSubview(containerView)
        
        editElements()
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 30),
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
            
            acceptMessageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            acceptMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            acceptMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),

            stackView.topAnchor.constraint(equalTo: acceptMessageLabel.bottomAnchor, constant: 15),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 25),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -25),
            stackView.heightAnchor.constraint(equalToConstant: 60)

        ])
    }
}


// MARK: - SwiftUI

//import SwiftUI
//
//struct ChatRequestVCProvider: PreviewProvider {
//    static var previews: some View{
//        ContainerView().edgesIgnoringSafeArea(.all)
//    }
//    
//    struct ContainerView: UIViewControllerRepresentable {
//        let chatRequestVC = ChatRequestViewController()
//        
//        func makeUIViewController(context: Context) -> some UIViewController {
//            return chatRequestVC
//        }
//        
//        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        }
//    }
//}
