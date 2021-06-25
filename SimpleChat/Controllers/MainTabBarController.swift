//
//  MainTabBarController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 29.04.2021.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    private let currentUser: UserModel
    
    init(currentUser: UserModel = UserModel(username: "Maksym Levytskyi",
                                            email: "hello alo",
                                            avatarStringURL: "helloalo",
                                            description: "heloalo",
                                            sex: "helo alo",
                                            id: "helo alo")) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.buttonBackgroungColorPurple()
        
        tabBar.barTintColor = .white
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let peopleImage = UIImage(systemName: "person.2.fill", withConfiguration: boldConfig)!
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right.fill", withConfiguration: boldConfig)!
        
        viewControllers = [
            getANavigationController(viewController: PeopleViewController(currentUser: currentUser), title: "Contacts", image: peopleImage),
            getANavigationController(viewController: ListViewController(currentUser: currentUser), title: "Conversation", image: conversationImage)
        ]
    }
    
    
    func getANavigationController(viewController: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        
        return navigationVC
    }
}
