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
            NotificationCenter.default.addObserver(self, selector: #selector(handleAudioInterruption),
                                                   name: AVAudioSession.interruptionNotification, object: nil)

            try audioSession.setCategory(.playback, mode: .default, options: [
                .mixWithOthers,
                .allowAirPlay,
                .allowBluetooth,
                .allowBluetoothA2DP,
                .duckOthers
            ])
            try audioSession.setActive(true, options: [])
            print("Audio session configured successfully.")
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    @objc private func handleAudioInterruption(notification: Notification) {
        guard let info = notification.userInfo,
              let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else { return }

        if type == .began {
            print("Audio session interrupted.")
        } else if type == .ended {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to reactivate audio session: \(error.localizedDescription)")
            }
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
