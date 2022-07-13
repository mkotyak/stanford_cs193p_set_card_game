import Foundation
import SwiftUI

class ColorAdapter {
    func convertColor(color: ContentColor) -> Color {
        switch color {
        case .red:
            return .red
        case .green:
            return .green
        case .purple:
            return .purple
        }
    }
}
