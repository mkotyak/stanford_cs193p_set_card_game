import Foundation
import SwiftUI

extension View {
    func stacked(position: Int, in total: Int) -> some View {
        let totalOffset: CGFloat = 20
        let maxOffsetIndex: Int = 5
        let offsetIndex = Double(position)
        let offset = totalOffset / CGFloat(min(total, maxOffsetIndex))
        return self.offset(x: min(offsetIndex, Double(maxOffsetIndex)) * offset, y: 0)
    }
}
