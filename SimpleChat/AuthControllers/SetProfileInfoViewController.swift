//
//  SetProfileInfoViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 28.04.2021.
//

import UIKit
import FirebaseAuth
import SDWebImage

class SetProfileInfoViewController: UIViewController {
    let addPhotoView = AddPhotoView()
    
    let profileInfoLabel = UILabel(text: "Profile information", font: UIFont.avenirNextMedium27())
    let fullNameLabel = UILabel(text: "Full name")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    let fullNameTextField = OneLineTextField(font: UIFont.avenirNextMedium20())
    let aboutMeTextField = OneLineTextField(font: UIFont.avenirNextMedium20())
    
    let sexSegmentedControl = (UISegmentedControl(firstElement: "Male", secondElement: "Female"))
    
    let continueButton = UIButton(title: "Continue", titleColor: .white, backgroundColor: UIColor.buttonBackgroungColorPurple())
    

    private var currentUser: User
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
        fullNameTextField.text = currentUser.displayName
        
        if let googleImageURL = currentUser.photoURL{
            addPhotoView.avatarImage.sd_setImage(with: googleImageURL, completed: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpConstraints()
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        addPhotoView.plusButton.addTarget(self, action: #selector(plusButtontapped), for: .touchUpInside)
        
        fullNameTextField.textColor = .black
        aboutMeTextField.textColor = .black
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}

//MARK: - Actions

extension SetProfileInfoViewController{
    @objc func continueButtonTapped() {
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: addPhotoView.avatarImage.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
            case .success(_):
                FirestoreService.shared.getUserData(from: self.currentUser) { result in
                    switch result {
                    case .success(let muser):
                        let mainTabBarController = MainTabBarController(currentUser: muser)
                        mainTabBarController.modalPresentationStyle = .fullScreen
                        self.present(mainTabBarController, animated: true, completion: nil)
                    case .failure(let error):
                        self.showAlert(with: "Error", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc func plusButtontapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}


// MARK: - Setup constraints

extension SetProfileInfoViewController {
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
            profileInfoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            profileInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addPhotoView.topAnchor.constraint(equalTo: profileInfoLabel.bottomAnchor, constant: 30),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.heightAnchor.constraint(equalToConstant: 55),
            
            stackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
    }
}


//MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate


extension SetProfileInfoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        addPhotoView.avatarImage.image = image
    }
    
}

// MARK: - SwiftUI

import SwiftUI

struct SetProfileInfoVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let setProfileInfoVC = SetProfileInfoViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return setProfileInfoVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
