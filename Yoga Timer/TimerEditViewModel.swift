import Foundation
import Combine

class TimerEditViewModel: ObservableObject {
    @Published var duration: TimeInterval = 0
    
    private var timerManager: TimerManager
    private var timer: TimerModel?

    init(timerManager: TimerManager, timer: TimerModel? = nil) {
        self.timerManager = timerManager
        if let timer = timer {
            self.timer = timer
            self.duration = timer.duration
        }
    }

    func save() {
        if let timer = timer {
            timerManager.updateTimer(timer, with: duration)
        } else {
            timerManager.addTimer(duration: duration)
        }
    }

    func deleteTimer() {
        if let timer = timer {
            timerManager.deleteTimer(id: timer.id)
        }
    }

    // Computed property to expose timer for debugging
    var currentTimer: TimerModel? {
        return timer
    }
}
