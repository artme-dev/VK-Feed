//
//  VKNetworkService.swift
//  VK Feed
//
//  Created by Артём on 08.08.2021.
//

import Foundation

final class VKNetworkService{
    
    var vkAuthService: VKAuthService
    
    init(vkAuthService: VKAuthService){
        self.vkAuthService = vkAuthService
    }
    
    func getFeedData(){
        let filterParams = ["filters": "post,photo"]
        let url = createApiURL(path: VkAPI.feedPath, params: filterParams)
        print(String(describing: url))
    }
    
    private func createApiURL(path: String, params: [String: String]) -> URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = VkAPI.sheme
        urlComponents.host = VkAPI.host
        urlComponents.path = path
        let configuredParams = configuredParams(params)
        urlComponents.queryItems = configuredParams.map{ URLQueryItem(name: $0, value: $1) }
        return urlComponents.url
    }
    
    private func configuredParams(_ params: [String: String]) -> [String: String]{
        var configuredParams = params
        configuredParams["access_token"] = vkAuthService.accessToken
        configuredParams["v"] = VkAPI.version
        return configuredParams
    }
}
