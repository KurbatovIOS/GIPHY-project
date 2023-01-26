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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
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
        // cell is a bit roundedx§
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if let height = gifs[indexPath.row].height?.toCGFloat(), let width = gifs[indexPath.row].width?.toCGFloat() {
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 200, height: 200)
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

