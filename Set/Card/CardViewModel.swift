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
    
    var shape: String {
        switch card.content.shape {
        case .diamond:
            return "Damond"
        case .oval:
            return "Oval"
        case .squiggle:
            return "Squiggle"
        }
    }
    
    var shading: String {
        switch card.content.shading {
        case .open:
            return "with no shading"
        case .stripped:
            return "stripped"
        case .solid:
            return "filled"
        }
    }
}
