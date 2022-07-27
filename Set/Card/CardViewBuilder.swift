import Foundation
import SwiftUI

class CardViewBuilder {
    func build(for card: CardModel, isColorBlindModeEnabled: Bool) -> CardView {
        let viewModel = CardViewModel(
            card: card,
            isColorBlindModeEnabled: isColorBlindModeEnabled
        )
        return CardView(cardViewModel: viewModel)
    }
}
