import SwiftUI

struct SetRow: View {
    let index: Int
    @Binding var weight: String
    @Binding var reps: String
    @Binding var isCompleted: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Set number
            Text("\(index + 1)")
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .leading)
            
            // Weight TextField
            TextField("0", text: $weight)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
                .onChange(of: weight) { newValue in
                    if let double = Double(newValue) {
                        weight = String(format: "%.1f", double)
                    }
                }
            
            // Reps TextField
            TextField("0", text: $reps)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 70)
                .textFieldStyle(.roundedBorder)
                .onChange(of: reps) { newValue in
                    if let value = Int(newValue) {
                        reps = String(min(max(value, 1), 100))
                    }
                }
            
            Spacer()
            
            // Completion Checkbox
            Button {
                isCompleted.toggle()
            } label: {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isCompleted ? Theme.accentColor : .secondary)
            }
            .padding(.horizontal, 4)
        }
        .font(.subheadline)
        .padding(.horizontal)
        .contentShape(Rectangle())
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
} 