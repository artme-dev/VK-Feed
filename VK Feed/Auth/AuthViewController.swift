//
//  AuthViewController.swift
//  VK Feed
//
//  Created by Артём on 15.08.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .vkBackground
        view.addSubview(indicator)
        setConstraints()
        
        VKAuthService.shared.delegate = self
        VKAuthService.shared.wakeUpSession()
    }
    
    func setConstraints(){
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}

extension AuthViewController: VKAuthServiceDelegate{
    func authServiceNeedToPresent(viewController: UIViewController) {
        DispatchQueue.main.async {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func authenticationFinished() {
        DispatchQueue.main.async {
            [unowned self] in
            let feedViewController = UINavigationController(rootViewController: NewsFeedViewController())
            feedViewController.modalPresentationStyle = .fullScreen
            self.indicator.stopAnimating()
            self.present(feedViewController, animated: true, completion: nil)
            
        }
    }
    func authenticationFailed() {
        print(#function)
    }
}
