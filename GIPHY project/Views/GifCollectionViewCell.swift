//
//  CollectionViewCell.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SDWebImage

class GifCollectionViewCell: UICollectionViewCell {
    
    private let gifImageView = UIImageView()
    
    private let imageView = SDAnimatedImageView()
    
    func configureCell(using gif: Original) {
        
        addSubview(imageView)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        
        imageView.backgroundColor = .orange
        
        imageView.sd_setImage(with: URL(string: gif.url!))
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
