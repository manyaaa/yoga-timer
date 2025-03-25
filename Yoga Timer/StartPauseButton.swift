import SwiftUI

struct StartPauseButton: View {
    var isRunning: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isRunning ? "pause.circle.fill" : "play.circle.fill")
                .resizable()
                .frame(width: 104, height: 104)
                .foregroundColor(Color(hex: "#485BFF"))
        }
        .padding(.vertical, 24)
    }
}
