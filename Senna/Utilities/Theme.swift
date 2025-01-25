import SwiftUI

enum Theme {
    static let primaryColor = Color("AccentColor")
    static let backgroundColor = Color(.systemBackground)
    static let secondaryBackgroundColor = Color(.secondarySystemBackground)
    
    static let textColor = Color(.label)
    static let secondaryTextColor = Color(.secondaryLabel)
    
    static let spacing: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    
    static let animation = Animation.spring(response: 0.3, dampingFraction: 0.7)
}

extension View {
    func primaryButtonStyle() -> some View {
        self.buttonStyle(.borderedProminent)
            .tint(Theme.primaryColor)
    }
    
    func cardStyle() -> some View {
        self
            .padding()
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 2)
    }
} 