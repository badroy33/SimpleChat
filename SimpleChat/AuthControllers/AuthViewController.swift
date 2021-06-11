//
//  ViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 05.04.2021.
//

import UIKit
import FirebaseFirestore
import GoogleSignIn

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: #imageLiteral(resourceName: "SimpleChatLogo"), contentMode: .scaleAspectFit)
    
    let firstLabel = UILabel(text: "Get starded with")
    let secondLabel = UILabel(text: "Or sign up with")
    let thirdLabel = UILabel(text: "Already onboard?")
    
    let googleButton = UIButton(title: "Google", titleColor: UIColor.buttonDarkTextColor(), isShadow: true, backgroundColor: .white)
    let emailButton = UIButton(title: "Email", titleColor: .white, backgroundColor: UIColor.buttonBackgroungColorPurple())
    let loginButton = UIButton(title: "Login", titleColor: UIColor.buttonBackgroungColorPurple(), isShadow: true, backgroundColor: .white)

    let signUpVC = SignUpVIewController()
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        signUpVC.delegate = self
        loginVC.delegate = self
        
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    @objc private func emailButtonTapped(){
        present(signUpVC, animated: true, completion: nil)
    }
    
    @objc private func loginButtonTapped(){
        present(loginVC, animated: true, completion: nil)
    }
    
    @objc private func googleButtonTapped(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}



//MARK: - GIDSignInDelegate

extension AuthViewController: GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        AuthService.shared.loginWithGoogle(user: user, error: error) { (result) in
            switch result{
            case .success(let user):
                FirestoreService.shared.getUserData(from: user) { (result) in
                    switch result{
                    case .success(let muser):
                        let mainTabBarController = MainTabBarController(currentUser: muser)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        UIApplication.getTopViewController()?.present(mainTabBarController, animated: true, completion: nil)
                    case .failure(_):
                        UIApplication.getTopViewController()?.present(SetProfileInfoViewController(currentUser: user), animated: true, completion: nil)
                    }
                }
            case .failure(let error):
                UIApplication.getTopViewController()?.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
}


//MARK: - Setup constraints

extension AuthViewController {
    
    private func setUpConstraints(){
        googleButton.addGoogleImage()
        
        let googleView = ButtonsViews(label: firstLabel, button: googleButton)
        let emailView = ButtonsViews(label: secondLabel, button: emailButton)
        let loginView = ButtonsViews(label: thirdLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
                                        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
                                        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
                                     stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
    
    
}


extension AuthViewController: AuthNavigationDelegate{
    func tologinVC() {
        present(loginVC, animated: true, completion: nil)
    }
    
    func toSignUpVC() {
        present(signUpVC, animated: true, completion: nil)
    }
}

// MARK: - SwiftUI

import SwiftUI

struct AuthVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let authVC = AuthViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return authVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
