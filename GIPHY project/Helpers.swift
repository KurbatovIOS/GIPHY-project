//
//  Helpers.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation

class Helpers {
    
    static let shared = Helpers()
    
    let apiKey = "98559pKOhIQNByFgR90WhTcddLlDXt9i"
    let cellIdentifier = "itemCell"
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
