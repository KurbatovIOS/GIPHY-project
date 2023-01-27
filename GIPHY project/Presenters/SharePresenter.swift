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
    
    // MARK: - M
    
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
    
    func animation(view: UIView) {
        
        UIView.animate(withDuration: 0.5) {
            view.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.7) {
                view.alpha = 0
            }
        }
    }
}
