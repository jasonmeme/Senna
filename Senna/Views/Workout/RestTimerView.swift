import SwiftUI

struct RestTimerView: View {
    let duration: Int
    @State private var timeRemaining: Int
    @Environment(\.dismiss) private var dismiss
    
    init(duration: Int) {
        self.duration = duration
        self._timeRemaining = State(initialValue: duration)
    }
    
    var body: some View {
        VStack(spacing: Theme.spacing * 2) {
            Text("Rest Timer")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text(timeRemaining.formatted())
                .font(.system(size: 64, weight: .bold, design: .rounded))
            
            Button("Skip") {
                dismiss()
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                dismiss()
            }
        }
    }
} 