import SwiftUI

struct ActiveSetRow: View {
    let index: Int
    @Binding var set: SetData
    
    var body: some View {
        HStack(spacing: Theme.spacing) {
            Text("Set \(index + 1)")
                .foregroundStyle(.secondary)
            
            HStack {
                TextField("Weight", value: $set.weight, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(width: 60)
                    .multilineTextAlignment(.trailing)
                Text("kg")
                    .foregroundStyle(.secondary)
                
                Stepper("", value: $set.weight, in: 0...1000, step: 2.5)
                    .labelsHidden()
            }
            
            HStack {
                TextField("Reps", value: $set.reps, format: .number)
                    .keyboardType(.numberPad)
                    .frame(width: 40)
                    .multilineTextAlignment(.trailing)
                Text("reps")
                    .foregroundStyle(.secondary)
                
                Stepper("", value: $set.reps, in: 0...100, step: 1)
                    .labelsHidden()
            }
            
            Toggle("", isOn: $set.isCompleted)
                .labelsHidden()
        }
    }
} 
