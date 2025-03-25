import SwiftUI

struct TimerEditView: View {
    @ObservedObject var viewModel: TimerEditViewModel
    @Environment(\.presentationMode) var presentationMode

    let durations: [TimeInterval] = [
        15, 30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 720, 900, 1200, 1500, 1800, 2100, 2400, 2700, 3000, 3300, 3600
    ]

    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Add vertical spacing between elements
                Picker("Duration", selection: $viewModel.duration) {
                    ForEach(durations, id: \.self) { duration in
                        Text(duration.formattedDuration)
                            .foregroundColor(.white) // Set picker text color to white
                            .tag(duration)
                    }
                }
                //.padding(.top, 20)
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color(hex: "#191919"))
                .cornerRadius(10)
                .padding(.horizontal, 20) // Add horizontal padding for the picker

                Button(action: {
                    viewModel.save()
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .font(.montserrat(20, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color(hex: "#485BFF"))
                        .cornerRadius(30) // Change border radius to 30px
                        .padding(.horizontal, 20) // Add horizontal padding for the button
                }

                Spacer()
            }
            .background(Color(hex: "#191919").ignoresSafeArea(.all))
            .navigationBarTitle("Choose Duration", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                viewModel.deleteTimer()
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic_trash")
                    .foregroundColor(Color(hex: "#485BFF"))
            })
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Duration")
                        .font(.montserrat(20, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .onAppear {
                print("TimerEditView appeared with timer: \(String(describing: viewModel.currentTimer))")
            }
        }
    }
}

struct TimerEditView_Previews: PreviewProvider {
    static var previews: some View {
        TimerEditView(viewModel: TimerEditViewModel(timerManager: TimerManager()), onSave: {})
    }
}
