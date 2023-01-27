//
//  SharePresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 27.01.2023.
//

import Foundation
import UIKit
import Photos
import SnapKit

class SharePresenter {
        
    func saveItem(urlString: String, sender: UIViewController) {
        
        if let itemUrl = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: itemUrl) { (data, response, error) in
                
                guard data != nil && error == nil else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        sender.present(alert, animated: true)
                    }
                    
                    return
                }
                
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: data!, options: nil)
                })
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Saved!", message: "Picture has been saved to your photos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    sender.present(alert, animated: true)
                }
            }
            dataTask.resume()
        }
    }
}
