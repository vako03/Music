//
//  CenteredTabBar.swift
//  Music
//
//  Created by valeri mekhashishvili on 10.05.24.
//

import UIKit

class CenteredTabBar: UITabBar {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerY = bounds.height / 2
        
        var centerX: CGFloat = 0
        let buttonWidth = bounds.width / CGFloat(items?.count ?? 1)
        
        for (index, view) in subviews.enumerated() where view is UIControl {
            view.frame = CGRect(x: centerX, y: centerY - (view.bounds.height / 2), width: buttonWidth, height: view.bounds.height)
            centerX += buttonWidth
        }
    }
}
