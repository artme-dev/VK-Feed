//
//  WebImageVie.swift
//  VK Feed
//
//  Created by Артём on 16.08.2021.
//

import UIKit

extension UIImageView{
    func load(from url: URL?){
        
        guard let url = url else { return }
        
        let request = URLRequest(url: url)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            setImage(from: cachedResponse.data)
            return
        }
        
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: request) { [unowned self] data, response, error in
                self.setImage(from: data)
                cacheURLResponse(request: request, data: data, response: response)
            }.resume()
        }
    }
    
    private func setImage(from data: Data?) {
        guard let data = data else { return }
        let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.image = image
        }
    }
    
    private func cacheURLResponse(request: URLRequest, data: Data?, response: URLResponse?) {
        guard let data = data, let response = response else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: request)
    }
}
