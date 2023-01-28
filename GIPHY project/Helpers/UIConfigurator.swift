//
//  UIConfigurator.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 28.01.2023.
//

import Foundation
import UIKit
import SnapKit

class UIConfigurator {
    
    // MARK: Collection view layout configuration
    
    func configureLayout() -> UICollectionViewLayout {
        
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)))
        
        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))
        
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let pairItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)))
        
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
            repeatingSubitem: pairItem,
            count: 2)
        
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [mainItem, trailingGroup])
        
        let tripletItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)))
        
        tripletItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/9)),
            subitems: [tripletItem, tripletItem, tripletItem])
        
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [trailingGroup, mainItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(16/9)),
            subitems: [
                fullPhotoItem,
                mainWithPairGroup,
                tripletGroup,
                mainWithPairReversedGroup
            ]
        )
        
        let section = NSCollectionLayoutSection(group: nestedGroup)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    // MARK: - Basic tab configuration
    
    func createTabButton(title: String) -> UIButton {
        
        let button = UIButton()
        
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.title = title
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .white
        
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.width.equalTo(120)
        }
        
        return button
    }
    
    func createCopyButton(color: UIColor, title: String) -> UIButton {
        
        let button = UIButton()
        
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.tintColor = .white
        
        button.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        return button
    }
    
    // MARK: - Social media icon setup
    
    func createSocialImageView(index: Int) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.tag = index
        
        var imageName = ""
        
        switch index {
        case 0:
            imageName = "whatsapp"
        case 1:
            imageName = "instagram"
        case 2:
            imageName = "twitter"
        default:
            imageName = "twitter"
        }
        
        imageView.image = UIImage(named: imageName)
        
        return imageView
    }
    
    // MARK: - Get social media url to send picture
    
    func getAppURL(index: Int) -> String {
        
        var appURL = ""
        
        switch index {
        case 0:
            appURL = "whatsapp://send?text="
        case 1:
            appURL = "instagram://sharesheet?text="
        case 2:
            appURL = "https://twitter.com/intent/tweet?text="
        default:
            appURL = "https://twitter.com/intent/tweet?text="
        }
        
        return appURL
    }
    
    // MARK: - Custom alert fading animation
    
    func addFadinganimation(to view: UIView) {
        
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.7) {
                view.alpha = 0
            }
        }
    }
}
