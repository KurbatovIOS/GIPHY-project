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
    
    private let gifCollectionView: UICollectionView = {
       
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private let presenter = GifPresenter()
    
    private var gifs = [Original]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .black
        
        gifCollectionView.delegate = self
        gifCollectionView.dataSource = self
        
        presenter.delegate = self
        
        presenter.getTrendingGIFs()
        
        configureGifCollectionView()
    }
    
    private func configureGifCollectionView() {
        
        view.addSubview(gifCollectionView)
        
        gifCollectionView.backgroundColor = .clear
        gifCollectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: "GIFcell")
        
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
        guard let cell = gifCollectionView.dequeueReusableCell(withReuseIdentifier: "GIFcell", for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(using: gifs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = view.frame.width/2 - 10
        
        if let height = gifs[indexPath.row].height?.toCGFloat() {
            return CGSize(width: width, height: height)
        }
        else {
            return CGSize(width: width, height: 200)
        }
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

extension String {
    
    func toCGFloat() -> CGFloat? {
        if let number = NumberFormatter().number(from: self) {
            return CGFloat(truncating: number)
        }
        else {
            return nil
        }
    }
}

