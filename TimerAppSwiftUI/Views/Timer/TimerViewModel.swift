//
//  TimerViewModel.swift
//  TimerAppSwiftUI
//
//  Created by Alkın Çakıralar on 1.06.2022.
//

import SwiftUI
import AudioUnit

enum TimerState {
    case Stopped
    case Started
    case Paused
}

final class TimerViewModel : ObservableObject {
        
    @Published var loadingScale = 0.0
    
    @Published var circleDegree = 0.0

    @Published var circleTimer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @Published var countDownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Published var countDownViewOpacity = 1.0
    
    @Published var timerState: TimerState = .Stopped
    
    @Published var currentTime = 0
    
    func pauseTimer() {
        self.timerState = .Paused
        
        self.countDownTimer.upstream.connect().cancel()
        
        withAnimation {
            self.countDownViewOpacity = 1.0
        }
    }
    
    func stopTimer(vibratePhone: Bool) {
        if vibratePhone { self.vibratePhone() }
        
        self.timerState = .Stopped
        
        self.currentTime = 0
        self.countDownTimer.upstream.connect().cancel()
        
        withAnimation {
            self.countDownViewOpacity = 0.0
        }
    }
      
    func startTimer() {
        self.vibratePhone()

        self.timerState = .Started
        
        if self.currentTime == 0 {
            self.currentTime = 1
        }
        
        self.countDownTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        withAnimation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
            self.countDownViewOpacity = 1
        }
    }
    
    func getHourAndMinute(time: Int) -> String {
        return "\(self.converTimeToHour(time: time).0):\(self.converTimeToHour(time: time).1)"
    }
    
    func getSecond(time: Int) -> String {
        return ":\(self.converTimeToHour(time: time).2)"
    }
    
    private  func converTimeToHour(time: Int) -> (String, String, String) {
         let interval = TimeInterval(time)
        
         let hour = Int(interval) / 3600
         let minute = Int(interval) / 60 % 60
         let second = Int(interval) % 60

         return (String(format: "%02i", hour), String(format: "%02i", minute), String(format: "%02i", second))
    }
    
    private func vibratePhone() {
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {   }
    }
    
}
