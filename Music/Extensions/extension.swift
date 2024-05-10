//
//  extension.swift
//  Music
//
//  Created by valeri mekhashishvili on 10.05.24.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage?) {
        self.init()
        self.image = image
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UILabel {
    convenience init(text: String, fontSize: CGFloat, color: UIColor) {
        self.init()
        self.text = text
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIButton {
    static func createCustomButton(icon: UIImage) -> UIButton {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setImage(icon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.backgroundColor = nil
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
}
