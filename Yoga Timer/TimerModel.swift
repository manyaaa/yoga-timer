import Foundation

struct TimerModel: Identifiable, Codable {
    let id: UUID
    var duration: TimeInterval
    
    init(id: UUID = UUID(), duration: TimeInterval) {
        self.id = id
        self.duration = duration
    }
}

// Sample data for preview
extension TimerModel {
    static let sampleTimers: [TimerModel] = [
        TimerModel(duration: 300), // 5 minutes
        TimerModel(duration: 600), // 10 minutes
        TimerModel(duration: 900)  // 15 minutes
    ]
}

extension TimerModel: Equatable {
    static func == (lhs: TimerModel, rhs: TimerModel) -> Bool {
        return lhs.id == rhs.id
    }
}
