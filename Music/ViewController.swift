//
//  ViewController.swift
//  Music
//
//  Created by valeri mekhashishvili on 10.05.24.
//

import UIKit

class ViewController: UIViewController {
    

    let coverImage = UIImageView(image: UIImage(named: "swift"))
    let containerView = UIView()
    let soLongLabel = UILabel(text: "So Long, London", fontSize: 24, color: .white)
    let taylorSwiftLabel = UILabel(text: "Taylor Swift", fontSize: 16, color: .gray)

    // Add progress bar
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .blue // Adjust color as needed
        progressBar.progress = 0.5 // Set initial progress value
        return progressBar
    }()
    
//    let buttonsCover = UIImageView(image: UIImage(named: "buttonCover"))
    let backgroundColor = UIColor(red: 22/255, green: 20/255, blue: 17/255, alpha: 1.0)

    let stackView = UIStackView()
    let tabBar = UITabBar()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
        addButtonsToStack()
        setupTabBar()
    }
    
   func setupUI() {
       
       view.addSubview(coverImage)
       view.addSubview(soLongLabel)
       view.addSubview(taylorSwiftLabel)
       view.addSubview(progressBar)
//       view.addSubview(buttonsCover)
       containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

       stackView.axis = .horizontal // Set axis to horizontal
       stackView.spacing = 40
       stackView.translatesAutoresizingMaskIntoConstraints = false
       view.addSubview(stackView)
       stackView.backgroundColor = nil
       tabBar.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(tabBar)
       
       
       NSLayoutConstraint.activate([
        coverImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
        coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
        coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
        
        containerView.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 34),
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
        soLongLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        soLongLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
        
        taylorSwiftLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        taylorSwiftLabel.topAnchor.constraint(equalTo: soLongLabel.bottomAnchor, constant: 7),
        taylorSwiftLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        
        progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        progressBar.topAnchor.constraint(equalTo: taylorSwiftLabel.bottomAnchor, constant: 34),
        progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
        progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -21),
        
        stackView.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 34),
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        
        tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
            ])
     
        
        
    }

    func addButtonsToStack() {
        let buttonIcons: [UIImage] = [
            UIImage(named: "shuffle")!,
            UIImage(named: "skip-back")!,
            UIImage(named: "Ellipse 26")!,
            UIImage(named: "skip-forward")!,
            UIImage(named: "repeat")!
        ]
        
        for icon in buttonIcons {
            let button = UIButton.createCustomButton(icon: icon)
            stackView.addArrangedSubview(button)
        }
    }
    
    func setupTabBar() {
        let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: nil)
                let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "Group 160"), selectedImage: nil)
                let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "heart"), selectedImage: nil)
                
                // Assign items to the tab bar
                tabBar.setItems([tabBarItem1, tabBarItem2, tabBarItem3], animated: false)
                
                // Customize tab bar appearance
                tabBar.layer.cornerRadius = 20 // Set corner radius
                tabBar.layer.borderWidth = 1.0 // Set border width
                tabBar.layer.borderColor = UIColor.black.cgColor // Set border color
                tabBar.clipsToBounds = true // Clip to bounds
                
                // Add height constraint to the tab bar
                tabBar.heightAnchor.constraint(equalToConstant: 80).isActive = true // Adjust this value as needed
                
                // Add tab bar to view
    }


}

#Preview {
    ViewController()
}
