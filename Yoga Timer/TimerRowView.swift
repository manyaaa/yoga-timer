import SwiftUI

struct TimerRowView: View {
    var timer: TimerModel
    var deleteAction: () -> Void
    var editAction: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Text(timer.duration.formattedDuration)
                .font(.montserrat(24, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(height: 80)
        .background(Color(hex: "#1F1F1F"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .onTapGesture {
            editAction()
        }
        .swipeActions {
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct TimerRowView_Previews: PreviewProvider {
    static var previews: some View {
        TimerRowView(timer: TimerModel(duration: 300), deleteAction: {}, editAction: {})
    }
}
