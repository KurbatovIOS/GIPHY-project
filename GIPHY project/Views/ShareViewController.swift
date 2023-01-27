//
//  ShareViewController.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SDWebImage
import Photos

class ShareViewController: UIViewController {
    
    private let dismissButton = UIButton()
    private let shareButton = UIButton()
    
    private var copyLinkButton: UIButton!
    private var copyGifButton: UIButton!
    private var cancelButton: UIButton!
    
    private let gifImageView = SDAnimatedImageView()
    
    private let socialStack = UIStackView()
    
    private let presenter = SharePresenter()
    
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureDismissButton()
        configureShareButton()
        configureGIF()
        
        configureCancelButton()
        configureCopyGifButton()
        configureCopyLinkButton()
        
        configureSocialStack()
    }
    
    // MARK: - View configuration
    
    private func configureDismissButton() {
        
        view.addSubview(dismissButton)
        
        dismissButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        dismissButton.tintColor = .white
        
        dismissButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        dismissButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.equalToSuperview().offset(15)
        }
    }
    
    private func configureShareButton() {
        
        view.addSubview(shareButton)
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .white
        
        shareButton.addTarget(self, action: #selector(shareButtonTap), for: .touchUpInside)
        
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    private func configureGIF() {
        
        view.addSubview(gifImageView)
        
        gifImageView.backgroundColor = .orange
        
        if url != nil {
            DispatchQueue.main.async {
                self.gifImageView.sd_setImage(with: URL(string: self.url))
            }
        }
        
        gifImageView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
    
    private func configureCancelButton() {
        
        cancelButton = presenter.createCopyButton(color: .black, title: "Cancel")
        
        view.addSubview(cancelButton)
        
        cancelButton.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
    }
    
    private func configureCopyGifButton(){
        
        copyGifButton = presenter.createCopyButton(color: .darkGray, title: "Copy GIF")
        
        view.addSubview(copyGifButton)
        
        copyGifButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        
        copyGifButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(cancelButton.snp.top).offset(-5)
        }
    }
    
    private func configureCopyLinkButton(){
        
        copyLinkButton = presenter.createCopyButton(color: .blue, title: "Copy GIF Link")
        
        view.addSubview(copyLinkButton)
        
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        
        copyLinkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(copyGifButton.snp.top).offset(-5)
        }
    }
    
    private func configureSocialStack() {
        
        view.addSubview(socialStack)
        
        for i in 0..<7 {
            let image = UIImageView()
            var imageName = ""
            switch i {
            case 0:
                imageName = "imessage"
            case 1:
                imageName = "messenger"
            case 2:
                imageName = "snapchat"
            case 3:
                imageName = "whatsapp"
            case 4:
                imageName = "instagram"
            case 5:
                imageName = "facebook"
            case 6:
                imageName = "twitter"
            default:
                imageName = "imessage"
            }
            image.image = UIImage(named: imageName)
            socialStack.addArrangedSubview(image)
        }
        socialStack.axis = .horizontal
        socialStack.distribution = .equalSpacing
        
        socialStack.snp.makeConstraints { make in
            make.bottom.equalTo(copyLinkButton.snp.top).offset(-5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
    }
    
    
    
    // MARK: - Button actions
    
    @objc private func copyLink() {
        
        UIPasteboard.general.string = url
    }
    
    private func save() {
        
    }
    
    @objc private func dismissAction() {
        
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTap() {
        
        if let gifUrl = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: gifUrl) { (data, response, error) in
                
                guard data != nil && error == nil else { return }
                
                PHPhotoLibrary.shared().performChanges({
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: data!, options: nil)
                })
            }
            dataTask.resume()
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let alert = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "The GIF has been saved to your photos.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}
