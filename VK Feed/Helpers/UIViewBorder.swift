//
//  UIViewBorder.swift
//  VK Feed
//
//  Created by Артём on 11.08.2021.
//

import UIKit

extension UIView{
    
    enum ViewSide{
        case trailing, leading, top, bottom
    }
    
    func addBorder(to side: ViewSide, color: UIColor, thickness: CGFloat){
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        addSubview(border)
        
        border.backgroundColor = color
        switch side {
        case .leading, .trailing:
            border.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            border.topAnchor.constraint(equalTo: topAnchor).isActive = true
            border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .bottom, .top:
            border.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        
        switch side {
        case .leading:
            border.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        case .trailing:
            border.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        case .bottom:
            border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .top:
            border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
    }
}
