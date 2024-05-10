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
    private var timer: Timer?
    private var startTime: TimeInterval = 0
    private var duration: TimeInterval = 120 // 2 minutes in seconds
    private var countdownLabelLeading: UILabel!
    private var countdownLabelTrailing: UILabel!
    
    // Add progress bar
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.progressTintColor = .blue // Adjust color as needed
        progressBar.progress = 0 // Set initial progress value to 0
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        setupUI()
        addButtonsToStack()
        setupTabBar()
        
        // Set initial text of countdown labels to "0:00"
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
        
        // StackView setup
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.backgroundColor = nil
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        
        // Countdown labels setup
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
        
        // Set constraints
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
            
            // Countdown label constraints
            countdownLabelLeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            countdownLabelLeading.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 1),
            
            countdownLabelTrailing.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            countdownLabelTrailing.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 1)
        ])
        
        updateCountdownLabels()
    }
    
    func updateCountdownLabels() {
        let timeElapsed = Int(Date().timeIntervalSinceReferenceDate - startTime)
        let timeLeft = Int(duration) - timeElapsed
        
        let minutesElapsed = timeElapsed / 60
        let secondsElapsed = timeElapsed % 60
        
        let minutesLeft = timeLeft / 60
        let secondsLeft = timeLeft % 60
        
        countdownLabelLeading.text = String(format: "%02d:%02d", minutesElapsed, secondsElapsed)
        countdownLabelTrailing.text = String(format: "%02d:%02d", minutesLeft, secondsLeft)
    }
    
    func addButtonsToStack() {
        let buttonIcons: [UIImage] = [
            UIImage(named: "shuffle")!,
            UIImage(named: "skip-back")!,
            UIImage(named: "Ellipse 26")!, // The button you want to add action to
            UIImage(named: "skip-forward")!,
            UIImage(named: "repeat")!
        ]
        
        for (index, icon) in buttonIcons.enumerated() {
            let button = UIButton.createCustomButton(icon: icon)
            if index == 2 { // Index of "Ellipse 26" button
                button.addTarget(self, action: #selector(startProgressBar), for: .touchUpInside)
            }
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func startProgressBar() {
        if timer == nil { // If timer is not running, start it or resume from paused progress
            if progressBar.progress >= 1 { // If progress is complete, reset progress to 0
                progressBar.progress = 0
                startTime = Date().timeIntervalSinceReferenceDate
            } else { // If progress is not complete, resume from paused progress
                startTime = Date().timeIntervalSinceReferenceDate - Double(progressBar.progress) * duration
            }
            // Start the timer
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
        } else { // If timer is running, pause it
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func updateProgress() {
        let currentTime = Date().timeIntervalSinceReferenceDate
        let elapsedTime = currentTime - startTime
        let progress = Float(elapsedTime / duration)
        progressBar.progress = progress
        
        // If progress reaches 1, stop the timer
        if progress >= 1 {
            timer?.invalidate()
            timer = nil
        }
        
        updateCountdownLabels()
    }
    
    func setupTabBar() {
        // Create the tab bar
        let tabBar = CenteredTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        
        // Define tab bar item images
        let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: nil)
        let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "Group 160"), selectedImage: nil)
        let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "heart"), selectedImage: nil)
        
        // Assign items to the tab bar
        tabBar.setItems([tabBarItem1, tabBarItem2, tabBarItem3], animated: false)
        
        // Customize tab bar appearance
        tabBar.layer.cornerRadius = 20
        tabBar.layer.borderWidth = 1.0
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.clipsToBounds = true
        
        // Add height constraint to the tab bar
        tabBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Add constraints to position the tab bar at the bottom
        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0) // Distance from bottom
        ])
    }
}

#Preview {
    ViewController()
}
