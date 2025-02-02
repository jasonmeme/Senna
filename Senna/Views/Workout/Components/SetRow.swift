import SwiftUI

struct SetRow: View {
    let index: Int
    @Binding var weight: String
    @Binding var reps: Int
    
    var body: some View {
        HStack {
            Text("Set \(index + 1)")
                .foregroundStyle(.secondary)
            
            Spacer()
            
            // Weight TextField
            TextField("0", text: $weight)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
            
            Text("lbs ×")
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            
            // Reps Stepper
            Stepper("\(reps) reps", value: $reps, in: 1...100)
                .labelsHidden()
            
            Text("\(reps)")
                .frame(width: 30)
            
            Text("reps")
                .foregroundStyle(.secondary)
        }
        .font(.subheadline)
    }
} 