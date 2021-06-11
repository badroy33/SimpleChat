//
//  SignUpVIewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 27.04.2021.
//

import Foundation
import UIKit


class SignUpVIewController: UIViewController{
    
    let helloLabel = UILabel(text: "Hello, and welcome", font: UIFont.avenirNextMedium27())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    
    let emailTextField = OneLineTextField()
    let passwordTextField = OneLineTextField(secureText: true)
    let confirmPasswordTextField = OneLineTextField(secureText: true)

    
    let signUpButton = UIButton(title: "Sign Up", titleColor: .white, backgroundColor: UIColor.buttonBackgroungColorPurple())
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.buttonBackgroungColorPurple(), for: .normal)
        button.titleLabel?.font = UIFont.avenirNextMedium20()
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    weak var delegate: AuthNavigationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        textFieldsSetUp()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    
    @objc private func signUpButtonTapped(){

        AuthService.shared.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { (result) in
            switch result{
            case .success(let muser):
                self.present(SetProfileInfoViewController(currentUser: muser), animated: true, completion: nil)
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTapped(){
        dismiss(animated: true) {
            self.delegate?.tologinVC()
        }
    }
    
    private func textFieldsSetUp(){
        self.emailTextField.textColor = .black
        self.passwordTextField.textColor = .black
        self.confirmPasswordTextField.textColor = .black
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}


//MARK: = setupConstraints()

extension SignUpVIewController{
    private func setupConstraints(){
        let emailView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 10)
        let passwordView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 10)
        let confirmPasswordView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 10)
        
        let stackView = UIStackView(arrangedSubviews: [emailView, passwordView, confirmPasswordView, signUpButton], axis: .vertical, spacing: 30
        )
        
        let bottomStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis: .horizontal, spacing: 15)
        bottomStackView.alignment = .firstBaseline
        
        
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(helloLabel)
        view.addSubview(stackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 55),
            stackView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}


// MARK: - SwiftUI

import SwiftUI

struct SignUpVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let signUpVC = SignUpVIewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return signUpVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}



