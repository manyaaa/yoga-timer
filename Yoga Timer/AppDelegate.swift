import UIKit
import AVFoundation
import HealthKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAudioSession()
        requestHealthKitAuthorization()
        return true
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try audioSession.setActive(true)
            print("Audio session configured successfully.")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    private func requestHealthKitAuthorization() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}
