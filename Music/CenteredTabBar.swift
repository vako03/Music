//
//  CenteredTabBar.swift
//  Music
//
//  Created by valeri mekhashishvili on 10.05.24.
//

import UIKit

class CenteredTabBar: UITabBar {
    private var selectedButton: UIControl?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let centerY = bounds.height / 2
        var centerX: CGFloat = 0
        let buttonWidth = bounds.width / CGFloat(items?.count ?? 1)
        
        for (index, view) in subviews.enumerated() where view is UIControl {
            view.frame = CGRect(x: centerX, y: centerY - (view.bounds.height / 2), width: buttonWidth, height: view.bounds.height)
            centerX += buttonWidth
            
            let button = view as! UIControl
            button.addTarget(self, action: #selector(tabBarItemTapped(sender:)), for: .touchUpInside)
            button.tag = index
            
            if button.isSelected {
                selectedButton = button
                enlargeSelectedButton()
            }
        }
    }
    
    @objc func tabBarItemTapped(sender: UIControl) {
        guard selectedButton != sender else { return }
        
        selectedButton = sender
        enlargeSelectedButton()
        
        for view in subviews where view is UIControl && view != sender {
            UIView.animate(withDuration: 0.1) {
                view.transform = .identity
            }
        }
        print("Tab bar item tapped: \(sender.tag)")
    }
    
    private func enlargeSelectedButton() {
        UIView.animate(withDuration: 0.1) {
            self.selectedButton?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }
    }
}
