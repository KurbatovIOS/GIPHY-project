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
    
    private var gifCollectionView: UICollectionView!
    
    private var gifTabButton: UIButton!
    private var stickerTabButton: UIButton!
    
    private let presenter = HomePresenter()
    
    private var gifs = [Original]()
    private var stickers = [Original]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        presenter.gifDelegate = self
        presenter.stickerDelegate = self
        
        configureTabs()
        
        presenter.getTrendingGIFs()
        presenter.getTrendingStickers()
        
        configureGifCollectionView()
        
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureGifCollectionView() {
        
        let layout = presenter.configureLayout()
        
        gifCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(gifCollectionView)
        
        gifCollectionView.backgroundColor = .clear
        gifCollectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: Helpers.shared.cellIdentifier)
        
        gifCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(stickerTabButton.snp.bottom).offset(5)
        }
    }
    
    private func configureTabs() {
        
        gifTabButton = presenter.createTabButton(title: "GIFs")
        stickerTabButton = presenter.createTabButton(title: "Stickers")
        
        gifTabButton.configuration?.baseBackgroundColor = .systemPurple
    
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
        
        stickerTabButton.configuration?.baseBackgroundColor = .clear
        gifTabButton.configuration?.baseBackgroundColor = .systemPurple
    }
    
    @objc private func stickerTabPress() {
        
        gifTabButton.configuration?.baseBackgroundColor = .clear
        stickerTabButton.configuration?.baseBackgroundColor = .systemPurple
    }
    
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return gifs.count
        return stickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gifCollectionView.dequeueReusableCell(withReuseIdentifier: Helpers.shared.cellIdentifier, for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        //cell.configureCell(using: gifs[indexPath.row])
        cell.configureCell(using: stickers[indexPath.row], isSticker: true)
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //if let url = gifs[indexPath.row].url {
        
        if let url = stickers[indexPath.row].url {
            let shareVC = ShareViewController()
            shareVC.modalPresentationStyle = .overFullScreen
            
            shareVC.url = url
            
            present(shareVC, animated: true)
        }
    }
}

extension TrendingViewController: GifPresenterDelegate, StickerPresenterDelegate {
    func stickerRetrieved(_ stickers: [Original]) {
        self.stickers = stickers
        gifCollectionView.reloadData()
    }
    
    func gifRetrieved(_ gifs: [Original]) {
        self.gifs = gifs
        gifCollectionView.reloadData()
    }
}

