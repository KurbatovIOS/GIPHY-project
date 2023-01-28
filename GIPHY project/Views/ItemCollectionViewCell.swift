//
//  CollectionViewCell.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import UIKit
import SDWebImage

final class ItemCollectionViewCell: UICollectionViewCell {
    
    private let imageView = SDAnimatedImageView()
    private let colors: [UIColor] = [.cyan, .systemPurple]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureCell(using item: Downsized, isSticker: Bool) {
        
        let randomInt = Int.random(in: 0..<colors.count)
        backgroundColor = isSticker ? .clear : colors[randomInt]
        
        if let urlString = item.url {
            guard let url = URL(string: urlString) else { return }
            
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: url)
            }
        }
    }
    
    private func setupView() {
        addSubview(imageView)
        
        layer.cornerRadius = 5
        clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
