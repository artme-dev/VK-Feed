//
//  NewsFeedInteractor.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import UIKit

protocol NewsFeedBusinessLogic
{
    func fetchFeed()
    func addFeedContinuation()
}

class NewsFeedInteractor: NewsFeedBusinessLogic{
    var presenter: NewsFeedPresentationLogic?
    private let dataFetcher = VKNetworkDataFetcher()
    
    private var isLoadingFeedData: Bool = false
    private var nextFrom: String?
    
    func fetchFeed() {
        fetchFeed(startFrom: nil) { [weak self] feedResponse, hasContinuation in
            let wrappedResponse = NewsFeed.ShowPosts.Response(response: feedResponse, hasContinuation: hasContinuation)
            self?.presenter?.presentPosts(response: wrappedResponse)
        }
    }
    
    func addFeedContinuation() {
        guard let nextFrom = nextFrom else { return }
        fetchFeed(startFrom: nextFrom) { [weak self] feedResponse, hasContinuation  in
            let wrappedResponse = NewsFeed.ShowPosts.Response(response: feedResponse, hasContinuation: hasContinuation)
            self?.presenter?.addPosts(response: wrappedResponse)
        }
    }
    
    private func fetchFeed(startFrom: String?, completion: @escaping (VKFeedResponse, Bool)->()){
        guard isLoadingFeedData == false else { return }
        isLoadingFeedData = true
        
        dataFetcher.fetchFeed(startFrom: startFrom) { [weak self] feedResponse in
            guard let feedResponse = feedResponse else { return }
            let hasContinuation = feedResponse.nextFrom != nil
            completion(feedResponse, hasContinuation)
            
            self?.nextFrom = feedResponse.nextFrom
            self?.isLoadingFeedData = false
        }
    }
}
