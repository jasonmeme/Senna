import SwiftUI

struct EmptyTemplatesView: View {
    var body: some View {
        VStack(spacing: Theme.spacing) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 40))
                .foregroundStyle(.secondary)
            
            Text("No Templates Yet")
                .font(.headline)
            
            Text("Create your first workout template to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Theme.secondaryBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
} 