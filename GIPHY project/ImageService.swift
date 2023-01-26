//
//  ImageService.swift
//  GIPHY project
//
//  Created by Kurbatov Artem on 26.01.2023.
//

import Foundation

import UIKit

struct ImageService {
    final class Delegate: NSObject {
        let completion: (Error?) -> Void

        init(completion: @escaping (Error?) -> Void) {
            self.completion = completion
        }

        @objc func savedImage(_ im: UIImage, error: Error?, context: UnsafeMutableRawPointer?) {
            DispatchQueue.main.async {
                self.completion(error)
            }
        }
    }

    func addToPhotos(image: UIImage, completion: @escaping (Error?) -> Void) {
        let delegate = Delegate(completion: completion)
        UIImageWriteToSavedPhotosAlbum(image, delegate, #selector(Delegate.savedImage(_:error:context:)), nil)
    }
}
