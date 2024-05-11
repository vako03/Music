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
    let backgroundColor = UIColor(red: 22/255, green: 20/255, blue: 17/255, alpha: 1.0)
    let stackView = UIStackView()
    let tabBar = UITabBar()
    var timer: Timer?
    var startTime: TimeInterval = 0
    var duration: TimeInterval = 120
    var countdownLabelLeading: UILabel!
    var countdownLabelTrailing: UILabel!
    var timePaused: TimeInterval = 0
    var isPaused: Bool = false
    
    let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .blue
        progressBar.progress = 0
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
        addButtonsToStack()
        setupTabBar()
        
        countdownLabelLeading.text = "00:00"
        countdownLabelTrailing.text = "02:00"
    }
    
    func setupUI() {
        // Add subviews
        view.addSubview(coverImage)
        view.addSubview(soLongLabel)
        view.addSubview(taylorSwiftLabel)
        view.addSubview(progressBar)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        countdownLabelLeading = UILabel()
        countdownLabelLeading.textColor = .white
        countdownLabelLeading.textAlignment = .center
        countdownLabelLeading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownLabelLeading)
        
        countdownLabelTrailing = UILabel()
        countdownLabelTrailing.textColor = .white
        countdownLabelTrailing.textAlignment = .center
        countdownLabelTrailing.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownLabelTrailing)
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
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
            
            countdownLabelLeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            countdownLabelLeading.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 1),
            
            countdownLabelTrailing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            countdownLabelTrailing.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 1)
        ])
        
    }
    
    func addButtonsToStack() {
        let buttonIcons: [UIImage] = [
            UIImage(named: "shuffle")!,
            UIImage(named: "skip-back")!,
            UIImage(named: "play")!,
            UIImage(named: "skip-forward")!,
            UIImage(named: "repeat")!
        ]
        
        for (index, icon) in buttonIcons.enumerated() {
            let button = UIButton()
            button.setImage(icon, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            if index == 2 { // Index of play button
                button.setBackgroundImage(UIImage(named: "Ellipse"), for: .normal)
            }
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if let playButton = stackView.arrangedSubviews[2] as? UIButton {
            if sender == playButton {
                if isPaused {
                    resumeTimer()
                } else {
                    startStopTimer()
                }
            }
        }
    }
    
    func setupTabBar() {
        let tabBar = CenteredTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        
        let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: nil)
        let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "music"), selectedImage: nil)
        let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "heart"), selectedImage: nil)
        
        tabBar.setItems([tabBarItem1, tabBarItem2, tabBarItem3], animated: false)
        
        tabBar.barTintColor = UIColor(red: 10/255, green: 9/255, blue: 30/255, alpha: 1.0)
        tabBar.layer.cornerRadius = 20
        tabBar.clipsToBounds = true
        
        tabBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

