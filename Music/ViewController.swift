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
    private var timePaused: TimeInterval = 0
    private var isPaused: Bool = false
    
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
            UIImage(named: "play")!, // The button you want to add action to
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
        // Assuming play/pause button is at index 2
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
    
    func startStopTimer() {
        if timer == nil { // If timer is not running, start it
            self.startTime = Date().timeIntervalSinceReferenceDate - self.timePaused
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            if let playButton = self.stackView.arrangedSubviews[2] as? UIButton {
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
            self.isPaused = false
            
            // Show loading animation only if the timer was previously paused
            if self.timePaused > 0 {
                showLoadingAnimation {
                    self.animateCoverImage(minimize: false) // Restore cover image
                }
            } else {
                self.animateCoverImage(minimize: false) // Restore cover image
            }
        } else { // If timer is running, stop it
            self.timePaused = Date().timeIntervalSinceReferenceDate - self.startTime
            self.timer?.invalidate()
            self.timer = nil
            if let playButton = self.stackView.arrangedSubviews[2] as? UIButton {
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
            self.isPaused = true
            self.animateCoverImage(minimize: true) // Minimize cover image
        }
    }

    func resumeTimer() {
        startStopTimer()
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
    
    func animateCoverImage(minimize: Bool) {
        UIView.animate(withDuration: 0.3) {
            if minimize {
                // Scale down the cover image
                self.coverImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } else {
                // Restore original size of the cover image
                self.coverImage.transform = .identity
            }
        }
    }
    
    func showLoadingAnimation(completion: @escaping () -> Void) {
        let loaderSize: CGFloat = 50 // Adjust loader size as needed
        let loaderFrame = CGRect(x: (view.bounds.width - loaderSize) / 2, y: (view.bounds.height - loaderSize) / 2, width: loaderSize, height: loaderSize)
        
        let loadingView = UIView(frame: loaderFrame)
        loadingView.backgroundColor = .clear
        view.addSubview(loadingView)
        
        let lineWidth: CGFloat = 4.0
        let radius = min(loadingView.bounds.width, loadingView.bounds.height) / 2 - lineWidth / 2
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: loadingView.bounds.midX, y: loadingView.bounds.midY), radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor // Set track color
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        loadingView.layer.addSublayer(trackLayer)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor // Set progress color
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        loadingView.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5 // Set animation duration
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "loadingAnimation")
        
        // Hide loading animation after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                loadingView.alpha = 0
            }) { _ in
                loadingView.removeFromSuperview()
                completion() // Call completion block when animation is finished
            }
        }
    }



    
    func setupTabBar() {
        // Create the tab bar
        let tabBar = CenteredTabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBar)
        
        // Define tab bar item images
        let tabBarItem1 = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: nil)
        let tabBarItem2 = UITabBarItem(title: nil, image: UIImage(named: "music"), selectedImage: nil)
        let tabBarItem3 = UITabBarItem(title: nil, image: UIImage(named: "heart"), selectedImage: nil)
        
        // Assign items to the tab bar
        tabBar.setItems([tabBarItem1, tabBarItem2, tabBarItem3], animated: false)
        
        // Customize tab bar appearance
        tabBar.barTintColor = UIColor(red: 10/255, green: 9/255, blue: 30/255, alpha: 1.0) // Background color
        tabBar.layer.cornerRadius = 20
        tabBar.clipsToBounds = true
        
        // Apply shadow to tab bar
        tabBar.layer.shadowColor = UIColor(red: 168/255, green: 186/255, blue: 207/255, alpha: 1.0).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.shadowRadius = 10
        
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

