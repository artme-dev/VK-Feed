//
//  StringBoundHeight.swift
//  VK Feed
//
//  Created by Артём on 16.08.2021.
//

import UIKit

extension String{
    
    func boundingRectHeight(width: CGFloat, font: UIFont) -> CGFloat{
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingRect = self.boundingRect(with: textSize,
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font : font],
                                             context: nil)
        return ceil(boundingRect.height)
    }
}
