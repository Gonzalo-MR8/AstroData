//
//  UIImageView+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

extension UIImageView {
    private func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from urlString: String?, placeholder: UIImage? = nil) {
        guard let image = urlString, image.count > 0, let url = URL(string: image) else {
            self.image = placeholder
            return
        }
        
        getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                self.image = placeholder
                return
            }

            DispatchQueue.main.async() { [weak self] in
                self?.image = UIImage(data: data)
            }
        }
    }
}

