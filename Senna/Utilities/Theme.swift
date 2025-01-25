import SwiftUI

enum Theme {
    // Brand Colors
    static let primaryGreen = Color(hex: "C9EFC7")
    static let secondaryBrown = Color(hex: "276930")
    
    static let primaryColor = primaryGreen
    static let accentColor = secondaryBrown
    static let backgroundColor = Color(.systemBackground)
    static let secondaryBackgroundColor = Color(.secondarySystemBackground)
    
    static let textColor = Color(.label)
    static let secondaryTextColor = Color(.secondaryLabel)
    
    // Spacing and Sizing
    static let spacing: CGFloat = 16
    static let cornerRadius: CGFloat = 12
    static let buttonHeight: CGFloat = 50
    static let maxWidth: CGFloat = 300
    
    static let animation = Animation.spring(response: 0.3, dampingFraction: 0.7)
}

extension View {
    func primaryButtonStyle() -> some View {
        self
            .frame(maxWidth: Theme.maxWidth, minHeight: Theme.buttonHeight)
            .background(Theme.accentColor)
            .foregroundColor(.white)
            .cornerRadius(Theme.cornerRadius)
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .frame(maxWidth: Theme.maxWidth, minHeight: Theme.buttonHeight)
            .background(Theme.primaryColor)
            .foregroundColor(Theme.accentColor)
            .cornerRadius(Theme.cornerRadius)
    }
    
    func textFieldStyle() -> some View {
        self
            .textFieldStyle(.plain)
            .padding()
            .frame(maxWidth: Theme.maxWidth, minHeight: Theme.buttonHeight)
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
    }
    
    func cardStyle() -> some View {
        self
            .padding()
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 2)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 