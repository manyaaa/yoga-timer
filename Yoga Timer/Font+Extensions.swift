import SwiftUI

extension Font {
    static func montserrat(_ size: CGFloat, weight: MontserratWeight = .regular) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}

enum MontserratWeight: String {
    case light = "Montserrat-Light"
    case regular = "Montserrat-Regular"
    case medium = "Montserrat-Medium"
    case semibold = "Montserrat-SemiBold"
    case bold = "Montserrat-Bold"
}
