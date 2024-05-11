//
//  TimerControlDelegate.swift
//  Music
//
//  Created by valeri mekhashishvili on 11.05.24.
//

import Foundation

protocol TimerControlDelegate: AnyObject {
    func startStopTimer()
    func resumeTimer()
    func updateProgress()
    func updateCountdownLabels()
}
