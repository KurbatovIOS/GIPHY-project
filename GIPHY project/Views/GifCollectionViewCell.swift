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
    
    private let colors: [UIColor] = [.cyan, .systemPurple]
    
    func configureCell(using gif: Original, isSticker: Bool) {
        
        addSubview(imageView)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        
        let randomInt = Int.random(in: 0..<colors.count)
        
        imageView.backgroundColor = isSticker ? .clear : colors[randomInt]
        
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: URL(string: gif.url!))
        }
    
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
