import SwiftUI

struct RunningTimerView: View {
    @ObservedObject var viewModel: RunningTimerViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()
            if let currentTimer = viewModel.timerManager.currentTimer {
                Text(currentTimer.duration.formattedDuration)
                    .font(.montserrat(80, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                Text("")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            Spacer()
            StartPauseButton(isRunning: viewModel.timerManager.isRunning) {
                viewModel.togglePauseResume()
            }
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onTapGesture {  // ✅ NEW: Allows tapping anywhere to play/pause
            viewModel.togglePauseResume()
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onChange(of: viewModel.timerManager.allTimersCompleted) { completed in
            if completed {
                presentationMode.wrappedValue.dismiss()
            }
        }

    }

    private var backButton: some View {
        Button(action: {
            viewModel.handleEditing()
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image("ic_back")
               //Text("Edit timers")
            }
            .foregroundColor(Color(hex: "#485BFF")) // Customize the color if needed
        }
    }
}

struct RunningTimerView_Previews: PreviewProvider {
    static var previews: some View {
        RunningTimerView(viewModel: RunningTimerViewModel(timerManager: TimerManager()))
    }
}
