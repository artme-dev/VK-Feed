//
//  PostActionButton.swift
//  VK Feed
//
//  Created by Артём on 15.08.2021.
//

import UIKit

class PostActionButton: UIButton {
    
    struct Constants {
        static let fontSize: CGFloat = 14
        static let textLeftInset: CGFloat = 4
        static let contentInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    var contentTitle: String? {
        set {
            setTitle(newValue, for: .normal)
            setInsets()
        }
        get {
            title(for: .normal)
        }
    }

    func commonInit(){
        backgroundColor = .vkElementBackground
        setTitleColor(.vkElement, for: .normal)
        
        titleLabel?.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)
        setInsets()
    }
    
    func setInsets(){
        let textLeftInset = title(for: .normal) != nil ? Constants.textLeftInset : .zero
        var customContentInsets = Constants.contentInsets
        customContentInsets.right += textLeftInset
        contentEdgeInsets = customContentInsets
        titleEdgeInsets = UIEdgeInsets(top: .zero, left: textLeftInset, bottom: .zero, right: -textLeftInset)
    }
    
    func setContentImage(named imageName: String){
        setImage(UIImage(named: imageName), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
    }
}
