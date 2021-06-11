//
//  PeopleViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 29.04.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class PeopleViewController: UIViewController {

    
    var users = [UserModel]()
    var usersListener: ListenerRegistration?
    var collectionView: UICollectionView!
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, UserModel>!
    
    private let currentUser: UserModel
    
    enum Section: Int, CaseIterable{
        case users
        func description(usersCount: Int) -> String{
            switch self {
            case .users:
                return "\(usersCount) people nearby"
            }
        }
    }
    
    
    init(currentUser: UserModel){
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        usersListener?.remove()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainWhiteColor()
        setUpSearchBar()
        setUpCollectionView()
        setUpNavigationBar()
        createDataSource()
        
        usersListener = ListenerService.shared.usersObserve(users: users, completion: { (result) in
            switch result{
            case .success(let users):
                self.users = users
                self.reloadData(with: nil)
            case .failure(let error):
                self.showAlert(with: "Error", message: error.localizedDescription)
            }
        })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Sign out", style:  .plain, target: self, action: #selector(signOut))
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
        
        collectionView.delegate = self
    }
    
    
    private func setUpNavigationBar(){
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
        searchController.searchBar.searchTextField.textColor = .black
        let glassIconView = searchController.searchBar.searchTextField.leftView as? UIImageView

        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


//MARK: - UICollectionViewDelegate

extension PeopleViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = self.diffableDataSource.itemIdentifier(for: indexPath) else { return }
        let profileVC = ProfileViewController(user: user)
        present(profileVC, animated: true, completion: nil)
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
            sectionHeader.configure(text: section.description(usersCount: items.count), textColor: .black, font: .systemFont(ofSize: 36, weight: .light))
            
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
