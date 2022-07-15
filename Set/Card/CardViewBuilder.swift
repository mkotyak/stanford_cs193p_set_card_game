import Foundation
import SwiftUI

class CardViewBuilder {
    func build(for card: CardModel) -> CardView {
        let viewModel = CardViewModel(card: card)
        return CardView(cardViewModel: viewModel)
    }
}
