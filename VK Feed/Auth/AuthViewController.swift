//
//  AuthViewController.swift
//  VK Feed
//
//  Created by Артём on 15.08.2021.
//

import UIKit

class AuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .vkBackground
        
        VKAuthService.shared.delegate = self
        VKAuthService.shared.wakeUpSession()
    }
}

extension AuthViewController: VKAuthServiceDelegate{
    func authServiceNeedToPresent(viewController: UIViewController) {
        DispatchQueue.main.async {
//            viewController.modalPresentationStyle = .fullScreen
//            viewController.modalTransitionStyle = .crossDissolve
//            viewController.view.backgroundColor = .white
            
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func authenticationFinished() {
        DispatchQueue.main.async {
            let feedViewController = UINavigationController(rootViewController: NewsFeedViewController())
            
            feedViewController.modalPresentationStyle = .fullScreen
//            feedViewController.modalTransitionStyle = .crossDissolve
            
            self.present(feedViewController, animated: true, completion: nil)
            
        }
    }
    func authenticationFailed() {
        print(#function)
    }
}
