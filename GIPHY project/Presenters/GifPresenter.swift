//
//  GifPresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation

protocol GifPresenterDelegate {
    
    func gifRetrieved(_ gifs: [Original])
}

class GifPresenter {
    
    var delegate: GifPresenterDelegate?
    
    func getTrendingGIFs() {
        
        let urlString = "https://api.giphy.com/v1/gifs/trending?&api_key=\(Helpers().apiKey)"
        
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
}
