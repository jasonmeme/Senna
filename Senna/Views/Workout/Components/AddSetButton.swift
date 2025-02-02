import SwiftUI

struct AddSetButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label("Add Set", systemImage: "plus.circle.fill")
                .font(.subheadline)
                .foregroundColor(Theme.accentColor)
        }
        .padding(.top, Theme.spacing/2)
    }
} 