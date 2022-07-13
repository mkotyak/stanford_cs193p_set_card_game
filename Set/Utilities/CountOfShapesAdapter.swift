import Foundation

class CountAdapter {
    func convertCount(count: NumOfShapes) -> Int {
        switch count {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
}
