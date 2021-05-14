//
//  MainTabBarController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 29.04.2021.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.buttonBackgroungColorPurple()
        
        tabBar.barTintColor = .white
        let boldConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let peopleImage = UIImage(systemName: "person.2.fill", withConfiguration: boldConfig)!
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right.fill", withConfiguration: boldConfig)!
        
        viewControllers = [
            getANavigationController(viewController: PeopleViewController(), title: "Contacts", image: peopleImage),
            getANavigationController(viewController: ListViewController(), title: "Conversation", image: conversationImage)
        ]
    }
    
    
    func getANavigationController(viewController: UIViewController, title: String, image: UIImage) -> UINavigationController{
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        
        return navigationVC
    }
}
