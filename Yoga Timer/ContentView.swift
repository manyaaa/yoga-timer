import SwiftUI

struct ContentView: View {
    
    @State private var healthKitAuthorized = false

    var body: some View {
        VStack {
            if healthKitAuthorized {
                TimerListView(viewModel: TimerListViewModel())
            } else {
                VStack(spacing: 16) {
                    Text("HealthKit access is required to log meditation sessions.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("Open Health Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .defaultFont() // Applies the default Montserrat font globally
        .onAppear {
            healthKitAuthorized = HealthKitManager.shared.getAuthorizationStatus() == .sharingAuthorized
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
