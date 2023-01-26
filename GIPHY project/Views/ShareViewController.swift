//
//  ShareViewController.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SDWebImage

class ShareViewController: UIViewController {
    
    private let dismissButton = UIButton()
    private let shareButton = UIButton()
    
    private let gifImageView = SDAnimatedImageView()
    
    private let socialStack = UIStackView()
    
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureDismissButton()
        configureShareButton()
        configureGIF()
    }
    
    // MARK: - View configuration
    
    private func configureDismissButton() {
        
        view.addSubview(dismissButton)
        
        dismissButton.setImage(UIImage(systemName: "multiply"), for: .normal)
        dismissButton.tintColor = .white
        
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)
        
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
    
    
    
    // MARK: - Button actions
    
    @objc private func dismissButtonTap() {
        
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTap() {
        
        // TODO: Save GIF
        
        guard let image = gifImageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
