//
//  GifPresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation
import UIKit

protocol GifPresenterDelegate {
    
    func gifRetrieved(_ gifs: [Original])
}

class GifPresenter {
    
    var delegate: GifPresenterDelegate?
    
    func getTrendingGIFs() {
        
        let urlString = "https://api.giphy.com/v1/gifs/trending?&api_key=\(Helpers.shared.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            
            guard data != nil && error == nil else { return }
            
            do {
                let data = try JSONDecoder().decode(Response.self, from: data!).data
                
                var gifs = [Original]()
                
                for gif in data {
                    gifs.append(gif.images.original)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.gifRetrieved(gifs)
                }
            }
            catch {
                
            }
        }
        dataTask.resume()
    }
    
    func configureLayout() -> UICollectionViewLayout {
        
        let fullPhotoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/3)))

        fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(2/3), heightDimension: .fractionalHeight(1.0)))

        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        // 2
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

        // 1
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
}
