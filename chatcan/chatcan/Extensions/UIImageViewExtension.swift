//
//  UIImageViewExtension.swift
//  chatcan
//
//  Created by Can Babaoğlu on 29.05.2022.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString: String) {
        self.image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        guard let url = URL(string: urlString) else {
           // self.image = UIImage(named: "empty-profile-icon")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                    }                    
                }
            }
        }.resume()
    }
}

extension UIImage {
    func resized(newSize: CGSize) -> UIImage {
        let scale = newSize.height / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newSize.height)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
