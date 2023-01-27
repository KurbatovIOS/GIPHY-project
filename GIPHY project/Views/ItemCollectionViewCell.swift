//
//  CollectionViewCell.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SDWebImage

class ItemCollectionViewCell: UICollectionViewCell {
    
    private let itemImageView = UIImageView()
    
    private let imageView = SDAnimatedImageView()
    
    private let colors: [UIColor] = [.cyan, .systemPurple]
    
    func configureCell(using item: Picture, isSticker: Bool) {
        
        addSubview(imageView)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        
        let randomInt = Int.random(in: 0..<colors.count)
        
        backgroundColor = isSticker ? .clear : colors[randomInt]
        
        DispatchQueue.main.async {
            self.imageView.sd_setImage(with: URL(string: item.url!))
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
