import SwiftUI

struct WorkoutTimerView: View {
    let elapsedTime: TimeInterval
    
    var body: some View {
        VStack {
            Text(elapsedTime.formattedTime)
                .font(.system(size: 56, weight: .semibold, design: .monospaced))
            Text("Elapsed Time")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}