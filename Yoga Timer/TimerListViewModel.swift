import Foundation
import Combine

class TimerListViewModel: ObservableObject {
    @Published var timers: [TimerModel] = [] {
        didSet {
            saveTimers() // ✅ Save whenever timers change
        }
    }
    var timerManager = TimerManager()
    
    private let userDefaultsKey = "savedTimers"

    init() {
        loadTimers() // ✅ Load timers when the app starts
    }

    func deleteTimer(at offsets: IndexSet) {
        offsets.forEach { index in
            let timer = timers[index]
            timerManager.deleteTimer(id: timer.id)
        }
        timers = timerManager.timers

        if timers.isEmpty {
            restoreDefaultTimers() // ✅ Restore defaults if all timers are deleted
        }
    }

    func startTimers() {
        timerManager.timers = timers
        timerManager.startTimers()
    }

    func addTimer(duration: TimeInterval) {
        let newTimer = TimerModel(duration: duration)
        timerManager.addTimer(duration: duration)
        timers = timerManager.timers
    }

    func updateTimers() {
        timers = timerManager.timers
    }

    // ✅ Save timers to UserDefaults
    private func saveTimers() {
        let timerDurations = timers.map { $0.duration }
        UserDefaults.standard.set(timerDurations, forKey: userDefaultsKey)
    }

    // ✅ Load timers from UserDefaults
    private func loadTimers() {
        if let savedDurations = UserDefaults.standard.array(forKey: userDefaultsKey) as? [TimeInterval], !savedDurations.isEmpty {
            timers = savedDurations.map { TimerModel(duration: $0) }
            timerManager.timers = timers
        } else {
            restoreDefaultTimers() // ✅ Load defaults if no timers are saved
        }
    }

    // ✅ Restore default timers (5, 10, 15 min)
    private func restoreDefaultTimers() {
        timers = [
            TimerModel(duration: 300),  // 5 minutes
            TimerModel(duration: 600),  // 10 minutes
            TimerModel(duration: 900)   // 15 minutes
        ]
        timerManager.timers = timers
        saveTimers() // ✅ Ensure defaults are saved
    }
}
