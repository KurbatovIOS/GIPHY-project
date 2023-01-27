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
    private var copyItemButton: UIButton!
    private var cancelButton: UIButton!
    
    private let itemImageView = SDAnimatedImageView()
    
    private let socialStack = UIStackView()
    
    private let presenter = SharePresenter()
    
    private let customAlertView = UIView()
    private let alertMessageLabel = UILabel()
    
    var currentTab: HomePresenter.CurrentTab!
    
    var url: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        configureDismissButton()
        configureShareButton()
        configureItem()
        
        configureCancelButton()
        configureCopyGifButton()
        configureCopyLinkButton()
        
        configureSocialStack()
        
        configureCustomAlertView()
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
    
    private func configureItem() {
        
        view.addSubview(itemImageView)
        
        itemImageView.backgroundColor = currentTab == .gif ? .cyan : .clear
        
        if url != nil {
            DispatchQueue.main.async {
                self.itemImageView.sd_setImage(with: URL(string: self.url))
            }
        }
        
        itemImageView.snp.makeConstraints { make in
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
        
        let type = currentTab == .gif ? "GIF" : "Sticker"
        
        copyItemButton = presenter.createCopyButton(color: .darkGray, title: "Copy \(type)")
        
        view.addSubview(copyItemButton)
        
        copyItemButton.addTarget(self, action: #selector(copyGIF), for: .touchUpInside)
        
        copyItemButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(cancelButton.snp.top).offset(-10)
        }
    }
    
    private func configureCopyLinkButton(){
        
        let type = currentTab == .gif ? "GIF" : "Sticker"
        
        copyLinkButton = presenter.createCopyButton(color: .blue, title: "Copy \(type) Link")
        
        view.addSubview(copyLinkButton)
        
        copyLinkButton.addTarget(self, action: #selector(copyLink), for: .touchUpInside)
        
        copyLinkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(copyItemButton.snp.top).offset(-10)
        }
    }
    
    private func configureSocialStack() {
        
        view.addSubview(socialStack)
        
        for i in 0..<3 {
            let socialImageView = presenter.createSocialImageView(index: i)
            socialImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendMessage)))
            socialStack.addArrangedSubview(socialImageView)
        }
        socialStack.axis = .horizontal
        socialStack.alignment = .trailing
        socialStack.distribution = .equalSpacing
        
        socialStack.snp.makeConstraints { make in
            make.bottom.equalTo(copyLinkButton.snp.top).offset(-10)
            make.leading.equalTo(view.snp.centerX)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(40)
        }
    }
    
    private func configureCustomAlertView() {
        
        view.addSubview(customAlertView)
        customAlertView.addSubview(alertMessageLabel)
        
        customAlertView.alpha = 0
        customAlertView.backgroundColor = .lightGray
        customAlertView.layer.cornerRadius = 10
        
        alertMessageLabel.text = "Copied!"
        alertMessageLabel.textColor = .white
        alertMessageLabel.textAlignment = .center
        alertMessageLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        customAlertView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.25)
            make.height.equalTo(customAlertView.snp.width)
            make.centerX.centerY.equalToSuperview()
        }
        
        alertMessageLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Button actions
    
    @objc private func copyLink() {
        
        UIPasteboard.general.string = url
        presenter.animation(view: customAlertView)
    }
    
    @objc private func copyGIF() {
        
        if let gifUrl = URL(string: url) {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: gifUrl) { (data, response, error) in
                
                guard data != nil && error == nil else { return }
                
                UIPasteboard.general.setData(data!, forPasteboardType: "com.compuserve.gif")
                
                DispatchQueue.main.async {
                    self.presenter.animation(view: self.customAlertView)
                }
            }
            dataTask.resume()
        }
    }
    
    @objc private func dismissAction() {
        
        dismiss(animated: true)
    }
    
    @objc private func shareButtonTap() {
        
        presenter.saveItem(urlString: url, sender: self)
    }
    
    @objc private func sendMessage(tapGestureRecognizer: UITapGestureRecognizer) {
        
        let socialView = tapGestureRecognizer.view as! UIImageView
        
        let appURL = presenter.getAppURL(index: socialView.tag)
        
        let queryCharSet = NSCharacterSet.urlQueryAllowed
        
        if let message = url.addingPercentEncoding(withAllowedCharacters: queryCharSet) {
            if let finalURL = URL(string: appURL + message) {
                if UIApplication.shared.canOpenURL(finalURL) {
                    UIApplication.shared.open(finalURL, options: [: ], completionHandler: nil)
                } else {
                    let alert = UIAlertController(title: "Oops...", message: "Coudn't launch application", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                    present(alert, animated: true)
                }
            }
        }
    }
}
