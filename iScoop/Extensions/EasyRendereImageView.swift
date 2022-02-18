//
//  UIImageView+Extension.swift
//  iScoop
//
//  Created by Taral Rathod on 16/02/22.
//

import Foundation
import UIKit

public class EasyRendererImageView: UIImageView {

    // Cache object
    let imageCache = NSCache<NSURL, UIImage>()

    public func getImageFor(url: URL, placeholder: UIImage, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        // Assigning Placeholder image
        self.image = placeholder

        // Checking in cache memory if not available than going for download
        if let cachedImage = imageCache.object(forKey: url as NSURL) {
            self.image = image
            completion(cachedImage, nil)
        } else {
//            guard let url = URL(string: url) else {print("Invalid URL"); return}
            let resource = Resource(url: url, method: .get)
            NetworkManager().downloadImage(resource) { [weak self] (data, error) in
                if error != nil {
                    completion(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    self?.imageCache.setObject(image, forKey: url as NSURL)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                    completion(image, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
}
