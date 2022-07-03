//
//  Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/6/22.
//

import UIKit

class Utils {
    
    static let shared = Utils()
    
    func downloadUIImage(with imageUrlString: String?, completion: ((UIImage?) -> Void)?) {
        ImageDownloader.shared.downloadImage(with: imageUrlString) { image in
            DispatchQueue.main.async {
                completion?(image)
            }
        }
    }
}
