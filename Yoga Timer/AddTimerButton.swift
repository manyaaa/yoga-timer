import SwiftUI

struct AddTimerButton: View {
    var addAction: () -> Void
    
    var body: some View {
        Button(action: {
            addAction()
        }) {
            Text("Add")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "#485BFF"))
                .frame(height: 36)
                .padding(.horizontal, 20)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color(hex: "#485BFF"), lineWidth: 1)
                )
                .cornerRadius(18)
        }
        .padding(.top, 20)
    }
}

struct AddTimerButton_Previews: PreviewProvider {
    static var previews: some View {
        AddTimerButton {
            print("Add button pressed")
        }
    }
}
