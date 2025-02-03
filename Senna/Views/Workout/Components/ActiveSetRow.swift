import SwiftUI

struct ActiveSetRow: View {
    let index: Int
    @Binding var set: SetData
    
    var body: some View {
        HStack(spacing: 12) {
            // Set number
            Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
            
            // Weight TextField
            TextField("0", value: $set.weight, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
            
            // Reps TextField
            TextField("0", value: $set.reps, format: .number)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
                .onChange(of: set.reps) { newValue in
                    set.reps = min(max(newValue, 1), 100)
                }
            
            Spacer()
            
            // Completion Checkbox
            Button {
                set.isCompleted.toggle()
            } label: {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(set.isCompleted ? Theme.accentColor : .secondary)
            }
            .frame(width: 50)
        }
        .font(.subheadline)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                // TODO: Implement delete functionality
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
} 
