//
//  SetProfileInfoViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 28.04.2021.
//

import UIKit

class SetProfileInfoViewController: UIViewController {
    let addPhotoView = AddPhotoView()
    
    let profileInfoLabel = UILabel(text: "Profile information", font: UIFont.avenirNextMedium27())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: UIFont.avenirNextMedium18())
    let aboutMeTextField = OneLineTextField(font: UIFont.avenirNextMedium20())
    
    let sexSegmentedControl = (UISegmentedControl(firstElement: "Male", secondElement: "Female"))
    
    let continueButton = UIButton(title: "Continue", titleColor: .white, backgroundColor: UIColor.buttonBackgroungColorPurple())
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
    }

}


// MARK: - Setup constraints

extension SetProfileInfoViewController{
    private func setUpConstraints(){
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 10)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 10)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 10)
        
        let stackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, continueButton], axis: .vertical, spacing: 40)
        
        profileInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(profileInfoLabel)
        view.addSubview(addPhotoView)
        view.addSubview(stackView)
        
        
        
        NSLayoutConstraint.activate([
            profileInfoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            profileInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addPhotoView.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: 50),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.heightAnchor.constraint(equalToConstant: 55),
            
            stackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}

// MARK: - SwiftUI

import SwiftUI

struct SetProfileInfoVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let setProfileInfoVC = SetProfileInfoViewController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return setProfileInfoVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
