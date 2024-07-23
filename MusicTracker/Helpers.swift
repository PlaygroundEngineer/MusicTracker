import SwiftUI

extension UIScreen {
    static let height = UIScreen.main.bounds.height
    static let width = UIScreen.main.bounds.width
}

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            self.init(.gray)
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct CustomColors {
    static let black = "201E1D"
    static let gray = "343534"
    static let cream = "ECEBE4"
    static let tan = "DED4BA"
    static let green = "BDCE87"
    static let blue = "C5D7E3"
    static let pink = "F3C6B7"
    static let yellow = "E7DD7F"
    static let magenta = "DBA3C1"
    static let slate = "8CAAC8"
}
