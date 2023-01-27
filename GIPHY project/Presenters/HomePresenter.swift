//
//  GifPresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation
import UIKit
import SnapKit

protocol GifPresenterDelegate: AnyObject {
    
    func gifRetrieved(_ gifs: [Images])
}

protocol StickerPresenterDelegate: AnyObject {
    
    func stickerRetrieved(_ stickers: [Images])
}

class HomePresenter {
    
    weak var gifDelegate: GifPresenterDelegate?
    weak var stickerDelegate: StickerPresenterDelegate?
    
    enum CurrentTab {
        case gif
        case sticker
    }
    
    // MARK: - Loading data from API
    
    func getTrendingData(isSticker: Bool) {
        
        let section = isSticker ? "stickers" : "gifs"
        
        let urlString = "https://api.giphy.com/v1/\(section)/trending?&api_key=\(Helpers.shared.apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, urlResponse, error in
            
            guard data != nil && error == nil else { return }
            
            do {
                let data = try JSONDecoder().decode(Response.self, from: data!).data
                
                var items = [Images]()
                
                for item in data {
                    items.append(item.images)
                }
                
                DispatchQueue.main.async {
                    
                    if isSticker {
                        self.stickerDelegate?.stickerRetrieved(items)
                    }
                    else {
                        self.gifDelegate?.gifRetrieved(items)
                    }
                }
            }
            catch {
                print("Decoding error")
            }
        }
        dataTask.resume()
    }
}
