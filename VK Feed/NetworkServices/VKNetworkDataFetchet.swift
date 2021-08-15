//
//  VKData .swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import Foundation

protocol NetworkDataFetcher {
    func fetchFeed(completion: @escaping (VKFeedResponse?)->())
}

final class VKNetworkDataFetcher: NetworkDataFetcher{
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = VKNetworkService()){
        self.networkService = networkService
    }
    
    func fetchFeed(completion: @escaping (VKFeedResponse?)->()){
        let filterParams = ["filters": "post,photo"]
        networkService.request(path: VKApiConstants.Paths.feed, params: filterParams) { data, error in
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
            let stringFormat = String(data: data, encoding: .utf8)
            print(String(describing: stringFormat))
            
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
                
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch let error{
            print(error)
            return nil
        }
    }
}
