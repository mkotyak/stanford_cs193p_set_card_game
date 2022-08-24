import Foundation
import SwiftUI

class CardViewModel: ObservableObject {
    private enum Constants {
        static let selectedCardOpacity: Double = 0.2
    }
    
    @Published private var card: CardModel
    let isColorBlindModeEnabled: Bool
    
    init(card: CardModel, isColorBlindModeEnabled: Bool) {
        self.card = card
        self.isColorBlindModeEnabled = isColorBlindModeEnabled
    }
    
    var cardIsFaceUp: Bool {
        card.isCardFaceUp
    }
    
    var backroundColor: Color {
        if card.state == .isSelected {
            return Color.gray.opacity(Constants.selectedCardOpacity)
        } else {
            return Color.white
        }
    }
    
    var strokeColor: Color {
        if card.state == .isMatchedSuccessfully {
            return Color.green
        } else if card.state == .isMatchedUnsuccessfully {
            return Color.red
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
    
    var contentColorDefinition: String {
        switch card.content.color {
        case .green:
            return "Green"
        case .red:
            return "Red"
        case .purple:
            return "Purple"
        }
    }
    
    var shapeImage: Image {
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
    
    var isHinted: Bool {
        card.isHinted
    }
}
