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
    
    private let presenter = GifPresenter()
    
    private var gifs = [Original]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        presenter.delegate = self
        
        presenter.getTrendingGIFs()
        
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
    }
}

extension TrendingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = gifCollectionView.dequeueReusableCell(withReuseIdentifier: Helpers.shared.cellIdentifier, for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(using: gifs[indexPath.row])
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let shareVC = ShareViewController()
        shareVC.modalPresentationStyle = .overFullScreen
        
        shareVC.url = gifs[indexPath.row].url!
        
        present(shareVC, animated: true)
    }
}

extension TrendingViewController: GifPresenterDelegate {
    func gifRetrieved(_ gifs: [Original]) {
        self.gifs = gifs
        gifCollectionView.reloadData()
    }
}

