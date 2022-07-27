import Foundation
import SwiftUI

class CardViewBuilder {
    func build(for card: CardModel, _ isColorBlindModeEnabled: Bool) -> CardView {
        let viewModel = CardViewModel(card: card, isColorBlindModeEnabled)
        return CardView(cardViewModel: viewModel)
    }
}
