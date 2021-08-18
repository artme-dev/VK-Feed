//
//  VKData .swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import Foundation

protocol NetworkDataFetcher {
    func fetchFeed(startFrom: String?, completion: @escaping (VKFeedResponse?)->())
}

final class VKNetworkDataFetcher: NetworkDataFetcher{
    
    private let networkService: NetworkService
    private static let postCount = 15
    
    init(networkService: NetworkService = VKNetworkService()){
        self.networkService = networkService
    }
    
    func fetchFeed(startFrom: String? = nil, completion: @escaping (VKFeedResponse?)->()){
        var params = [String: String]()
        params["filters"] = "post,photo"
        params["start_from"] = startFrom
        params["count"] = String(VKNetworkDataFetcher.postCount)
            
        networkService.request(path: VKApiConstants.Paths.feed, params: params) { data, error in
            guard let data = data else {
                completion(nil)
                return
            }
            let responseWrapped = self.decode(type: VKFeedResponseWrapped.self, from: data)
            completion(responseWrapped?.response)
        }
    }
    
    private func decode<T: Decodable>(type: T.Type, from data: Data) -> T?{
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do{                
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch let error{
            print(error)
            return nil
        }
    }
}
