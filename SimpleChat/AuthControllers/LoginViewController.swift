//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 27.04.2021.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    let welcomeBackLabel = UILabel(text: "Welcome back", font: UIFont.avenirNextMedium27(), textColor: .buttonDarkTextColor())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    
    let googleButton = UIButton(title: "Google", titleColor: .buttonDarkTextColor(), isShadow: true, backgroundColor: .white)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .buttonBackgroungColorPurple())
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.buttonBackgroungColorPurple(), for: .normal)
        button.titleLabel?.font = UIFont.avenirNextMedium20()
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    let emailTextField = OneLineTextField(font: UIFont.avenirNextMedium18())
    let passwordTextField = OneLineTextField(font: UIFont.avenirNextMedium20())
    
    weak var delegate: AuthNavigationDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)

    }

    
    @objc private func loginButtonTapped(){
        AuthService.shared.login(email: emailTextField.text, password: passwordTextField.text) { (result) in
            switch result{
            case .success(let user):
//                self.showAlert(with: "Succes", message: "Your has been loged in")
                FirestoreService.shared.getUserData(from: user) { (result) in
                    switch result{
                    case .success(let muser):
                        let mainTabBarController = MainTabBarController(currentUser: muser)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self.present(mainTabBarController, animated: true, completion: nil)
                    case .failure(_):
                        self.present(SetProfileInfoViewController(currentUser: user), animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
        print(#function)
    }
    
    @objc private func signUpButtonTapped(){
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
        print(#function)
    }
    
    @objc private func googleButtonTapped(){
        print(#function)
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
}


// MARK: - Setup constraints

extension LoginViewController{
    
    private func setUpConstraints(){
        googleButton.addGoogleImage()
        
        let loginWithGoogleView = ButtonsViews(label: loginWithLabel, button: googleButton)
        
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 10)
        
        
        
        let stackView = UIStackView(arrangedSubviews: [
                                        loginWithGoogleView,
                                        orLabel,
                                        emailStackView,
                                        passwordStackView,
                                        loginButton],
                                    axis: .vertical,
                                    spacing: 40)
        
        let bottomView = UIStackView(arrangedSubviews: [
                                        needAnAccountLabel,
                                        signUpButton],
                                     axis: .horizontal,
                                     spacing: 15)
        
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        loginWithGoogleView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeBackLabel)
        view.addSubview(stackView)
        view.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 55),
            
            welcomeBackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            welcomeBackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            stackView.topAnchor.constraint(equalTo: welcomeBackLabel.bottomAnchor, constant: 100),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50)
        ])
        
        
    }
    
}


// MARK: - SwiftUI

import SwiftUI

struct LoginVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let loginVC = LoginViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return loginVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
