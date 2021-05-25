//
//  ListViewController.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 29.04.2021.
//

import UIKit

class ListViewController: UIViewController {
    
    
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable{
        case waitingChats, currentChats
        
        func setHeader() -> String{
            switch self {
            case .waitingChats:
                return "Waiting chats"
            case .currentChats:
                return "Current chats"
            }
        }
    }
    
    var diffableDataSource: UICollectionViewDiffableDataSource<Section, ChatModel>?
    
    let currentChats = [ChatModel]()
    let waitingChats = [ChatModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpSearchBar()
        createDataSource()
        reloadData()
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
    
    private func setUpCollectionView(){
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: self.getCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleHeight]
        collectionView.backgroundColor = UIColor.mainWhiteColor()
        view.addSubview(collectionView)
        
        collectionView.register(CurrentChatCell.self, forCellWithReuseIdentifier: CurrentChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
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
    
    func reloadData(){
        var snapShot = NSDiffableDataSourceSnapshot<Section, ChatModel>()
        snapShot.appendSections([.waitingChats, .currentChats])
        snapShot.appendItems(waitingChats, toSection: .waitingChats)
        snapShot.appendItems(currentChats, toSection: .currentChats)
        diffableDataSource?.apply(snapShot, animatingDifferences: true)
    }
}


// MARK: - Data Source

extension ListViewController{
    
    

    private func createDataSource(){
        diffableDataSource = UICollectionViewDiffableDataSource<Section, ChatModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError("Unknown section") }
            
            switch section{
            case .currentChats:
                return self.configure(collectionView: collectionView, cellType: CurrentChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
            }
        })
        
        diffableDataSource?.supplementaryViewProvider = {
            collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader else  { fatalError("Unable to create new section header")}
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            sectionHeader.configure(text: section.setHeader(), textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1), font: UIFont.laoSangamMN20())
            
            return sectionHeader
        }
        
    }
    
}



// MARK: - Setup layout

extension ListViewController{
    
    private func getCompositionalLayout() -> UICollectionViewLayout {
        let compositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex, layout) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { fatalError("Unknown section") }
            switch section{
            case .waitingChats:
                return self.createWaitingChatsSection()
            case .currentChats:
                return self.createCurrentChatsSection()
            }

        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        compositionalLayout.configuration = config
        return compositionalLayout
    }
    
    private func createCurrentChatsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//        group.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 10, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 8
        
        let sectionHeader = createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createWaitingChatsSection() -> NSCollectionLayoutSection{
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(84),
                                               heightDimension: .absolute(84))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 20
        
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

extension ListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
}



// MARK: - SwiftUI

import SwiftUI

struct ListVCProvider: PreviewProvider{
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
