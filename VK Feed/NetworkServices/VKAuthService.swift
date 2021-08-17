//
//  VKAuthService.swift
//  VK Feed
//
//  Created by Артём on 09.08.2021.
//

import Foundation
import SwiftyVK

protocol VKAuthServiceDelegate: AnyObject {
    func authServiceNeedToPresent(viewController: UIViewController)
    func authenticationFinished()
    func authenticationFailed()
}

final class VKAuthService{
    private let currentAppId = "7921565"
    private let scopes: Scopes = [Scopes.friends,
                                  Scopes.photos,
                                  Scopes.wall,
                                  Scopes.offline]
    
    weak var delegate: VKAuthServiceDelegate?
    var accessToken: String?
    
    static let shared = VKAuthService()
    
    private init(){
        VK.setUp(appId: currentAppId, delegate: self)
    }
    
    private func login(){
        VK.sessions.default.logIn(
            onSuccess: { _ in
                self.delegate?.authenticationFinished()
            },
            onError: { _ in
                self.delegate?.authenticationFailed()
            }
        )
    }
    
    func wakeUpSession(){
        let token = VK.sessions.default.accessToken
        
        guard
            let token = token,
            token.isValid
        else {
            login()
            return
        }
        
        accessToken = token.get()
        self.delegate?.authenticationFinished()
    }
    
    private func updateToken(){
        guard let token = VK.sessions.default.accessToken else { return }
        accessToken = token.get()
    }
}

extension VKAuthService: SwiftyVKDelegate{
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        delegate?.authServiceNeedToPresent(viewController: viewController)
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        updateToken()
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        updateToken()
    }
    
    func vkTokenRemoved(for sessionId: String) {
        accessToken = nil
    }
}
