import SwiftUI

struct WorkoutTimerView: View {
    let elapsedTime: TimeInterval
    
    var body: some View {
        VStack(spacing: 4) {
            Text(elapsedTime.formattedTime)
                .font(.system(size: 44, weight: .semibold, design: .monospaced))
            Text("Elapsed Time")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}