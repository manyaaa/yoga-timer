import SwiftUI
import Foundation
import Combine

struct TimerListView: View {
    @StateObject var viewModel = TimerListViewModel()
    @State private var showingEditSheet = false
    @State private var editingTimer: TimerModel?
    @State private var navigateToRunningTimer = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer().frame(height: 8)

                if viewModel.timers.isEmpty {
                    VStack {
                        Text("Add a timer to get started.")
                            .font(.montserrat(20, weight: .regular)) // ✅ Font size 20px, weight regular
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.top, 40) // ✅ 40px padding below nav bar
                            .frame(maxWidth: .infinity, alignment: .center) // ✅ Ensures it spans full width
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top) // ✅ Aligns text to top
                } else {
                    timerList
                    Spacer()

                    // ✅ Start Timer Button (Only visible when timers exist)
                    Button(action: {
                        viewModel.startTimers()
                        navigateToRunningTimer = true
                    }) {
                        Image(systemName: "play.circle.fill")
                            .resizable()
                            .frame(width: 104, height: 104)
                            .foregroundColor(Color(hex: "#485BFF"))
                            .padding(.vertical, 24)
                    }
                    .padding()
                }

                runningTimerNavigation
            }
            .background(Color.black.ignoresSafeArea()) // ✅ Ensures full-screen black background
            .navigationBarTitle("Yoga Timer", displayMode: .inline)
            .navigationBarItems(trailing: addTimerButton)
            .toolbar { toolbarTitle }
            .sheet(isPresented: $showingEditSheet, onDismiss: {
                viewModel.updateTimers()
            }) {
                TimerEditSheetContent(
                    editingTimer: $editingTimer,
                    viewModel: viewModel.timerManager,
                    onSave: {
                        showingEditSheet = false
                        viewModel.updateTimers()
                    }
                )
            }
        }
    }
}

// MARK: - Computed Properties
private extension TimerListView {
    var timerList: some View {
        List {
            ForEach(viewModel.timers) { timer in
                timerRow(for: timer)
            }
            .onDelete(perform: viewModel.deleteTimer)
            .listRowBackground(Color.black)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
        .background(Color.black)
        .scrollContentBackground(.hidden)
    }

    func timerRow(for timer: TimerModel) -> some View {
        HStack {
            Spacer()
            Text(timer.duration.formattedDuration)
                .font(.montserrat(24, weight: .medium))
                .foregroundColor(.white)
            Spacer()
        }
        .frame(height: 72)
        .background(Color(hex:"#191919"))
        .cornerRadius(10)
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .contentShape(Rectangle())
        .onTapGesture {
            editingTimer = timer
            showingEditSheet = true
        }
    }

    var addTimerButton: some View {
        Button(action: {
            viewModel.addTimer(duration: 300)
        }) {
            Image("ic_plus")
                .foregroundColor(Color(hex: "#486CE8"))
        }
    }

    var toolbarTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Your session")
                .font(.montserrat(20, weight: .bold))
                .foregroundColor(.white)
        }
    }

    var runningTimerNavigation: some View {
        NavigationLink(
            destination: RunningTimerView(viewModel: RunningTimerViewModel(timerManager: viewModel.timerManager)),
            isActive: $navigateToRunningTimer
        ) {
            EmptyView()
        }
    }
}

struct TimerListView_Previews: PreviewProvider {
    static var previews: some View {
        TimerListView()
    }
}
