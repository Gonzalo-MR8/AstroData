//
//  ImageDownloader.swift
//  InfoSpace
//
//  Created by GonzaloMR on 10/6/22.
//

import UIKit

final class ImageDownloader {

    static let shared = ImageDownloader()

    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]

    // A serial queue to be able to write the non-thread-safe dictionary
    let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)

    // MARK: Private init
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }

    func downloadImage(with imageUrlString: String?, placeholderImage: UIImage? = UIImage(named: "placeholderIcon"), completion: @escaping (UIImage?) -> Void) {

        guard let imageUrlString = imageUrlString else {
            completion(placeholderImage)
            return
        }

        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completion(image)
        } else {
            guard let url = URL(completedString: imageUrlString) else {
                completion(placeholderImage)
                return
            }

            if let _ = getDataTaskFrom(urlString: imageUrlString) {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                guard let data = data else {
                    completion(placeholderImage)
                    return
                }

                if let _ = error {
                    DispatchQueue.main.async {
                        completion(placeholderImage)
                    }
                    return
                }

                let image = UIImage(data: data)
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[imageUrlString] = image
                }

                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrlString)
                }

                DispatchQueue.main.async {
                    completion(image)
                }
            }
            // We want to control the access to no-thread-safe dictionary in case it's being accessed by multiple threads at once
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrlString] = task
            }

            task.resume()
        }
    }

    private func cancelPreviousTask(with urlString: String?) {
        if let urlString = urlString, let task = getDataTaskFrom(urlString: urlString) {
            task.cancel()
            // Since Swift dictionaries are not thread-safe, we have to explicitly set this barrier to avoid fatal error when it is accessed by multiple threads simultaneously
            _ = serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks.removeValue(forKey: urlString)
            }
        }
    }

    private func getCachedImageFrom(urlString: String) -> UIImage? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }

    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {
        // Reading from the dictionary should happen in the thread-safe manner.
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}
