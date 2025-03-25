import Foundation
import Combine
import AVFoundation
import UIKit
import HealthKit
import UserNotifications

class TimerManager: ObservableObject {
    @Published var timers: [TimerModel] = []
    @Published var remainingTime: Int = 0
    @Published var currentTimer: TimerModel? {
        didSet { DispatchQueue.main.async { self.objectWillChange.send() } }
    }
    @Published var isRunning: Bool = false
    @Published var allTimersCompleted: Bool = false

    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    private var audioPlayer: AVAudioPlayer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var backgroundTimer: DispatchSourceTimer?
    private var timerStartTimestamp: Date?
    private var meditationStartTime: Date?

    func startTimer(timer: TimerModel) {
        DispatchQueue.main.async {
            self.currentTimer = timer
            self.isRunning = true
            self.timerStartTimestamp = Date()
            self.saveTimerState()
            self.beginBackgroundTask()
        }
        
        backgroundTimer?.cancel()
        backgroundTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        backgroundTimer?.schedule(deadline: .now(), repeating: 1)

        backgroundTimer?.setEventHandler { [weak self] in
            DispatchQueue.main.async { self?.tick() } // ✅ Restore `tick()`
        }
        backgroundTimer?.resume()
    }

    // ✅ Restore `tick()` function for timer countdown
    private func tick() {
        guard var currentTimer = currentTimer else { return }
        if currentTimer.duration > 0 {
            currentTimer.duration -= 1
            self.remainingTime = Int(currentTimer.duration)
            self.currentTimer = currentTimer
        } else {
            completeTimer()
        }
    }

    private func completeTimer() {
        DispatchQueue.main.async {
            self.isRunning = false
            self.timer?.cancel()
            self.timer = nil
            self.playBellSound() // ✅ Restore `playBellSound()`

            if let currentIndex = self.timers.firstIndex(where: { $0.id == self.currentTimer?.id }) {
                if currentIndex < self.timers.count - 1 {
                    let nextTimer = self.timers[currentIndex + 1]
                    self.startTimer(timer: nextTimer)
                } else {
                    self.currentTimer = nil
                    self.allTimersCompleted = true
                    self.endBackgroundTask()
                    self.saveMeditationSession()
                }
            }
        }
    }

    // ✅ Restore `playBellSound()` function
    private func playBellSound() {
        if UIApplication.shared.applicationState == .active {
            DispatchQueue.main.async {
                guard let url = Bundle.main.url(forResource: "bell", withExtension: "mp3") else {
                    print("Bell sound file not found")
                    return
                }
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                    self.audioPlayer?.play()
                } catch {
                    print("Error: Could not load bell sound file. \(error.localizedDescription)")
                }
            }
        } else {
            sendBellNotification()
        }
    }

    private func sendBellNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Yoga Timer"
        content.body = "Time’s up! Your next timer is starting."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "bell.mp3"))

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "BellSound", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    private func saveMeditationSession() {
        guard let start = meditationStartTime else { return }
        let end = Date()
        HealthKitManager.shared.endMeditationSession(startDate: start, endDate: end)
    }
}
