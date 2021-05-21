//
//  PeopleViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 29.04.2021.
//

import UIKit
import FirebaseAuth

class PeopleViewController: UIViewController {

    
//    let users = Bundle.main.decode([UserModel].self, from: "users.json")
    let users = [UserModel]()
    var collectionView: UICollectionView!
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, UserModel>!
    
    enum Section: Int, CaseIterable{
        case users
        func description(usersCount: Int) -> String{
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhiteColor()
        setUpSearchBar()
        setUpCollectionView()
        createDataSource()
        reloadData(with: nil)
        users.forEach { (user) in
            print(user.username)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Sign out", style:  .plain, target: self, action: #selector(signOut))
    }
    
    private let currentUser: UserModel
    
    init(currentUser: UserModel){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func signOut(){
        let ac = UIAlertController(title: "", message: "Do you wan't to sign out?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let signOutAction = UIAlertAction(title: "Sign out", style: .destructive) { (_) in
            do{
                try Auth.auth().signOut()
                UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
            }catch{
                print("Error \(error.localizedDescription)")
            }
        }
        ac.addAction(cancelAction)
        ac.addAction(signOutAction)
        
        present(ac, animated: true, completion: nil)
    }

    private func setUpCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.getCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        collectionView.backgroundColor = UIColor.mainWhiteColor()
        view.addSubview(collectionView)
        
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.reuseId)
    }
    
    
    private func setUpSearchBar(){
        navigationController?.navigationBar.barTintColor = UIColor.mainWhiteColor()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func reloadData(with searchText: String?){
        var snapShot = NSDiffableDataSourceSnapshot<Section, UserModel>()
        
        let filtered = users.filter { (user) -> Bool in
            user.contains(filter: searchText)
        }
        snapShot.appendSections([.users])
        snapShot.appendItems(filtered, toSection: .users)

        diffableDataSource?.apply(snapShot, animatingDifferences: true)
    }
}

//MARK: - DataSource

extension PeopleViewController{
    private func createDataSource(){
        diffableDataSource = UICollectionViewDiffableDataSource<Section, UserModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            guard let section = Section(rawValue: indexPath.section) else {fatalError("unknown section kind")}
            
            switch section{
            case .users:
                return self.configure(collectionView: collectionView, cellType: UserCell.self, with: user, for: indexPath)
            }
        })
        
        diffableDataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else  { fatalError("Unable to create new section header")}
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            let items = self.diffableDataSource.snapshot().itemIdentifiers(inSection: .users)
            sectionHeader.configure(text: section.description(usersCount: items.count), textColor: .label, font: .systemFont(ofSize: 36, weight: .light))
            
            return sectionHeader
        }
    }
}

// MARK: - Setup layout

extension PeopleViewController{
    
    private func getCompositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layout) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section") }
            switch section{
            case .users:
                return self.createUserSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        compositionalLayout.configuration = config
        return compositionalLayout
    }
    
    private func createUserSection() -> NSCollectionLayoutSection{
        
        let spacing = CGFloat(15)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.6))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16)
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem{
        let sectionSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        return sectionHeader
    }
}

// MARK: - UISearchBarDelegate

extension PeopleViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadData(with: searchText)
    }
    
}



// MARK: - SwiftUI

import SwiftUI

struct PeopleVCProvider: PreviewProvider{
    static var previews: some View{
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        }
    }
}
