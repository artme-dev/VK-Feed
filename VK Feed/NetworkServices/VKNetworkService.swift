//
//  VKNetworkService.swift
//  VK Feed
//
//  Created by Артём on 08.08.2021.
//

import Foundation

protocol NetworkService {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?)->())
}

final class VKNetworkService: NetworkService{
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?)->()){
        let url = createApiURL(path: path, params: params)
        guard let url = url else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else { return }
                
            let statusCode = httpResponse.statusCode
            guard
                statusCode == 200
            else{
                print("Cannot get data from \(url)")
                print("Status code: \(statusCode)")
                if let error = error {
                    print(String(describing: error))
                }
                return
            }
                
            completion(data, error)
        }.resume()
    }
    
    private func createApiURL(path: String, params: [String: String]) -> URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = VKApiConstants.scheme
        urlComponents.host = VKApiConstants.host
        urlComponents.path = path
        let configuredParams = configuredParams(params)
        urlComponents.queryItems = configuredParams.map{ URLQueryItem(name: $0, value: $1) }
        return urlComponents.url
    }
    
    private func configuredParams(_ params: [String: String]) -> [String: String]{
        var configuredParams = params
        configuredParams["access_token"] = VKAuthService.shared.accessToken
        configuredParams["v"] = VKApiConstants.version
        return configuredParams
    }
}
