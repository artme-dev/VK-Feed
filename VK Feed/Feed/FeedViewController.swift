//
//  FeedViewController.swift
//  VK Feed
//
//  Created by Артём on 08.08.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    var networkService: VKNetworkService?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        networkService?.getFeedData()
    }

}
