//
//  GifPresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation
import UIKit
import SnapKit

protocol GifPresenterDelegate {
    
    func gifRetrieved(_ gifs: [Picture])
}

protocol StickerPresenterDelegate {
    
    func stickerRetrieved(_ stickers: [Picture])
}

class HomePresenter {
    
    var gifDelegate: GifPresenterDelegate?
    var stickerDelegate: StickerPresenterDelegate?
    
    enum CurrentTab {
        case gif
        case sticker
    }
    
    // MARK: - Loading data from API
    
    func getTrendingGIFs() {
        
        let urlString = "https://api.giphy.com/v1/gifs/trending?&api_key=\(Helpers.shared.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            
            guard data != nil && error == nil else { return }
            
            do {
                let data = try JSONDecoder().decode(Response.self, from: data!).data
                
                var gifs = [Picture]()
                
                for gif in data {
                    gifs.append(gif.images.original)
                }
                
                DispatchQueue.main.async {
                    self.gifDelegate?.gifRetrieved(gifs)
                }
            }
            catch {
                print("Decoding error")
            }
        }
        dataTask.resume()
    }
    
    func getTrendingStickers() {
        
        let urlString = "https://api.giphy.com/v1/stickers/trending?&api_key=\(Helpers.shared.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            
            guard data != nil && error == nil else { return }
            
            do {
                let data = try JSONDecoder().decode(Response.self, from: data!).data
                
                var stickers = [Picture]()
                
                for sticker in data {
                    stickers.append(sticker.images.original)
                }
                
                DispatchQueue.main.async {
                    self.stickerDelegate?.stickerRetrieved(stickers)
                }
            }
            catch {
                print("Decoding error")
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Collection view layout configuration
    
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
}
