//
//  ViewController.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SnapKit
import SDWebImage

class TrendingViewController: UIViewController {
    
    private var itemCollectionView: UICollectionView!
    
    private var gifTabButton: UIButton!
    private var stickerTabButton: UIButton!
    
    private let presenter = HomePresenter()
    
    private var gifs = [Picture]()
    private var stickers = [Picture]()
    
    private var currentTab = HomePresenter.CurrentTab.gif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        presenter.gifDelegate = self
        presenter.stickerDelegate = self
        
        configureTabs()
        
        presenter.getTrendingGIFs()
        presenter.getTrendingStickers()
        
        configureGifCollectionView()
        
        itemCollectionView.delegate = self
        itemCollectionView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureGifCollectionView() {
        
        let layout = presenter.configureLayout()
        
        itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(itemCollectionView)
        
        itemCollectionView.backgroundColor = .clear
        itemCollectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: Helpers.shared.cellIdentifier)
        
        itemCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(stickerTabButton.snp.bottom).offset(5)
        }
    }
    
    private func configureTabs() {
        
        gifTabButton = presenter.createTabButton(title: "GIFs")
        stickerTabButton = presenter.createTabButton(title: "Stickers")
        
        gifTabButton.configuration?.baseBackgroundColor = .purple
    
        gifTabButton.addTarget(self, action: #selector(gifTabPress), for: .touchUpInside)
        stickerTabButton.addTarget(self, action: #selector(stickerTabPress), for: .touchUpInside)
        
        view.addSubview(gifTabButton)
        view.addSubview(stickerTabButton)
        
        gifTabButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.snp.centerX).offset(-30)
        }
        
        stickerTabButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.centerX).offset(30)
        }
    }
    
    @objc private func gifTabPress() {
        
        if currentTab != .gif {
            
            stickerTabButton.configuration?.baseBackgroundColor = .clear
            gifTabButton.configuration?.baseBackgroundColor = .purple
            
            currentTab = .gif
            itemCollectionView.reloadData()
        }
    }
    
    @objc private func stickerTabPress() {
        
        if currentTab != .sticker {
            
            gifTabButton.configuration?.baseBackgroundColor = .clear
            stickerTabButton.configuration?.baseBackgroundColor = .purple
            
            currentTab = .sticker
            itemCollectionView.reloadData()
        }
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTab == .gif ? gifs.count : stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = itemCollectionView.dequeueReusableCell(withReuseIdentifier: Helpers.shared.cellIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        currentTab == .gif ? cell.configureCell(using: gifs[indexPath.row], isSticker: false) :  cell.configureCell(using: stickers[indexPath.row], isSticker: true)
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url = currentTab == .gif ? gifs[indexPath.row].url : stickers[indexPath.row].url
        
        if url != nil && url != "" {
            
            let shareVC = ShareViewController()
            shareVC.modalPresentationStyle = .overFullScreen
            
            shareVC.currentTab = currentTab
            shareVC.url = url
            
            present(shareVC, animated: true)
        }
    }
}

extension TrendingViewController: GifPresenterDelegate, StickerPresenterDelegate {
    func stickerRetrieved(_ stickers: [Picture]) {
        self.stickers = stickers
        itemCollectionView.reloadData()
    }
    
    func gifRetrieved(_ gifs: [Picture]) {
        self.gifs = gifs
        itemCollectionView.reloadData()
    }
}

