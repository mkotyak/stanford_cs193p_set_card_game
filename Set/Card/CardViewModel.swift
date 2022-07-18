import Foundation
import SwiftUI

class CardViewModel: ObservableObject {
    @Published private var card: CardModel
    
    init(card: CardModel) {
        self.card = card
    }
    
    var backroundColor: Color {
        if card.isActive {
            return Color.gray.opacity(0.2)
        } else {
            return Color.white
        }
    }
    
    var strokeColor: Color {
        if card.isSelected {
            return Color.green
        } else {
            return Color.black
        }
    }
    
    var numOfShapes: Int {
        switch card.content.numOfShapes {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
    }
    
    var contentColor: Color {
        switch card.content.color {
        case .green:
            return Color.green
        case .red:
            return Color.red
        case .purple:
            return Color.purple
        }
    }
    
    var shape: Image {
        switch card.content.shape {
        case .oval:
            switch card.content.shading {
            case .stripped:
                return Image("OvalStripped")
            case .solid:
                return Image("OvalFilled")
            case .open:
                return Image("OvalEmpty")
            }
        case .diamond:
            switch card.content.shading {
            case .stripped:
                return Image("DiamondStripped")
            case .solid:
                return Image("DiamondFilled")
            case .open:
                return Image("DiamondEmpty")
            }
        case .squiggle:
            switch card.content.shading {
            case .stripped:
                return Image("SquiggleStripped")
            case .solid:
                return Image("SquiggleFilled")
            case .open:
                return Image("SquiggleEmpty")
            }
        }
    }
}
