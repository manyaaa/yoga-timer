import Foundation
import UIKit
import Combine

class RunningTimerViewModel: ObservableObject {
    @Published var timerManager: TimerManager
    
    private var cancellables = Set<AnyCancellable>()

    init(timerManager: TimerManager) {
        self.timerManager = timerManager

        // ✅ Ensure view updates when `remainingTime` changes on the main thread
        timerManager.$remainingTime
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        // ✅ Listen for app resumption
        NotificationCenter.default.addObserver(self, selector: #selector(handleAppResumed), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func handleAppResumed() {
        print("App Resumed - Ensuring Timer is Up to Date")
        timerManager.resumeTimerAfterBackground() // ✅ Ensures correct time when app resumes
    }

    func togglePauseResume() {
        if timerManager.isRunning {
            timerManager.pauseTimer()
        } else {
            resumeTimer()
        }
    }

    private func resumeTimer() {
        guard let currentTimer = timerManager.currentTimer else { return }
        timerManager.startTimer(timer: currentTimer)
    }

    func handleEditing() {
        timerManager.pauseTimer()
    }
}
