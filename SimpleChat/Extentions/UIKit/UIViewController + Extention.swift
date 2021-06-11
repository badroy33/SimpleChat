//
//  UIViewController + Extention.swift
//  SimpleChat
//
//  Created by Maksym Levytskyi on 08.05.2021.
//

import UIKit

extension UIViewController{
     func configure<T: SelfCellConfiguration, U: Hashable>(collectionView: UICollectionView, cellType: T.Type,with value: U, for indexPath: IndexPath) -> T{
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Something wrong with \(cellType.reuseId)")
        }
        cell.configure(with: value)
        return cell
    }
}


extension UIViewController{
    func showAlert(with title: String, message: String){
        let aletrController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        aletrController.addAction(okAction)
        present(aletrController, animated: true, completion: nil)
    }
}

