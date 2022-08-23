import Foundation

class GameViewBuilder {
    func build(isColorBlindModeEnabled: Bool) -> GameView {
        let deckBuilder = DeckBuilder()
        let model = GameModel(
            deckBuilder: deckBuilder
        )
        let viewModel = GameViewModel(
            gameModel: model,
            isColorBlindModeEnabled: isColorBlindModeEnabled
        )

        return GameView(
            gameViewModel: viewModel,
            cardViewBuilder: CardViewBuilder()
        )
    }
}
