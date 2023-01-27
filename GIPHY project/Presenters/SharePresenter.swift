//
//  SharePresenter.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 27.01.2023.
//

import Foundation
import UIKit

class SharePresenter {
    
    
    func createCopyButton(color: UIColor, title: String) -> UIButton {
        
        let button = UIButton()
        
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.tintColor = .white
   
        return button
    }
}
