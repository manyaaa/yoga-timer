import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()
    
    // Meditation Type (Mindful Minutes)
    private let meditationType = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    
    // Store active session start time
    private var activeSessionStartTime: Date?

    // Check if HealthKit is available
    func isHealthKitAvailable() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }

    // Request authorization to write Mindful Minutes
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let typesToWrite: Set<HKSampleType> = [meditationType]

        healthStore.requestAuthorization(toShare: typesToWrite, read: nil) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ HealthKit authorization granted.")
                } else {
                    print("❌ HealthKit authorization failed: \(error?.localizedDescription ?? "Unknown error")")
                }
                completion(success, error)
            }
        }
    }

    // Get current HealthKit authorization status
    func getAuthorizationStatus() -> HKAuthorizationStatus {
        return healthStore.authorizationStatus(for: meditationType)
    }

    // ✅ Track active meditation session start time
    func startMeditationSession(startDate: Date) {
        activeSessionStartTime = startDate
        print("🧘 Meditation session started at \(startDate)")
    }

    // ✅ Check if a meditation session is running
    func isMeditationSessionActive() -> Bool {
        return activeSessionStartTime != nil
    }

    // ✅ End Meditation Session and Save to HealthKit
    func endMeditationSession(startDate: Date, endDate: Date) {
        guard getAuthorizationStatus() == .sharingAuthorized else {
            print("❌ HealthKit authorization not granted. Cannot save session.")
            return
        }

        let session = HKCategorySample(
            type: meditationType,
            value: HKCategoryValue.notApplicable.rawValue,
            start: startDate,
            end: endDate
        )

        healthStore.save(session) { success, error in
            DispatchQueue.main.async {
                if success {
                    print("✅ Meditation session saved to HealthKit: \(startDate) - \(endDate)")
                } else {
                    print("❌ Failed to save session: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }

        // Clear the active session state
        activeSessionStartTime = nil
    }
}
