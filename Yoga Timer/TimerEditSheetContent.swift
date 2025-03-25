import SwiftUI

struct TimerEditSheetContent: View {
    @Binding var editingTimer: TimerModel?
    var viewModel: TimerManager
    var onSave: () -> Void

    var body: some View {
        if let timer = editingTimer {
            TimerEditView(viewModel: TimerEditViewModel(timerManager: viewModel, timer: timer), onSave: onSave)
                .presentationDetents([.height(350)]) // Set height to 350px
                .presentationDragIndicator(.visible) // Show drag indicator
        } else {
            // A fallback view to ensure the sheet always has valid content
            Text("No timer selected")
                .frame(maxWidth: .infinity, maxHeight: 350)
                .background(Color.black)
                .foregroundColor(.white)
        }
    }
}
