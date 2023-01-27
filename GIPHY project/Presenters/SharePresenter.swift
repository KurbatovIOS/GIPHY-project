//
//  SharePresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 27.01.2023.
//

import Foundation
import UIKit
import Photos

class SharePresenter {
    
    
    func createCopyButton(color: UIColor, title: String) -> UIButton {
        
        let button = UIButton()
        
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.tintColor = .white
   
        return button
    }
    
    func saveGIF(urlString: String, sender: UIViewController) {
        
        if let gifUrl = URL(string: urlString) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: gifUrl) { (data, response, error) in
                
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
                    let alert = UIAlertController(title: "Saved!", message: "The GIF has been saved to your photos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    sender.present(alert, animated: true)
                }
            }
            dataTask.resume()
        }
    }
    
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
}
