import SwiftUI

struct StartTimerButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "play.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(Color(hex: "#485BFF"))
        }
        .padding()
    }
}
