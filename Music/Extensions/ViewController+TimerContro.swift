//
//  MusicPlayerViewModel.swift
//  Music
//
//  Created by valeri mekhashishvili on 10.05.24.
//

import UIKit

extension ViewController: TimerControlDelegate {
    func startStopTimer() {
        if timer == nil { 
            self.startTime = Date().timeIntervalSinceReferenceDate - self.timePaused
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            if let playButton = self.stackView.arrangedSubviews[2] as? UIButton {
                playButton.setImage(UIImage(named: "pause"), for: .normal)
            }
            self.isPaused = false
            
            if self.timePaused > 0 {
                showLoadingAnimation {
                    self.animateCoverImage(minimize: false)
                }
            } else {
                self.animateCoverImage(minimize: false)
            }
        } else {
            self.timePaused = Date().timeIntervalSinceReferenceDate - self.startTime
            self.timer?.invalidate()
            self.timer = nil
            if let playButton = self.stackView.arrangedSubviews[2] as? UIButton {
                playButton.setImage(UIImage(named: "play"), for: .normal)
            }
            self.isPaused = true
            self.animateCoverImage(minimize: true)
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
        
        if progress >= 1 {
            timer?.invalidate()
            timer = nil
        }
        
        updateCountdownLabels()
    }
    
    func animateCoverImage(minimize: Bool) {
        UIView.animate(withDuration: 0.3) {
            if minimize {
                self.coverImage.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            } else {
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
        trackLayer.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        loadingView.layer.addSublayer(trackLayer)
        
        let progressLayer = CAShapeLayer()
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = UIColor.blue.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        loadingView.layer.addSublayer(progressLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1.5
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        progressLayer.add(basicAnimation, forKey: "loadingAnimation")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            UIView.animate(withDuration: 0.3, animations: {
                loadingView.alpha = 0
            }) { _ in
                loadingView.removeFromSuperview()
                completion()
            }
        }
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
}
