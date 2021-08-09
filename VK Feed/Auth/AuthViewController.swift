//
//  AuthViewController.swift
//  VK Feed
//
//  Created by Артём on 08.08.2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    var vkAuthService: VKAuthService?
    
    private let authButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Авторизоваться", for: .normal)
        button.setTitleColor(UIColor(named: "VkBrandColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(authButton)
        configureAuthButton()
    }
    
    func configureAuthButton(){
        authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        authButton.addTarget(self, action: #selector(authenticate), for: .touchUpInside)
    }
    
    @objc func authenticate(){
        guard let service = vkAuthService else { return }
        service.wakeUpSession()
    }
}
