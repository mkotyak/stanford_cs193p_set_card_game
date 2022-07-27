import Foundation

class GameViewBuilder {
    func build(_ isColorBlindModeEnabled: Bool) -> GameView {
        let deckBuilder = DeckBuilder()
        let model = GameModel(
            deckBuilder: deckBuilder,
            firstPlayer: Player(name: "Player 1"),
            secondPlayer: Player(name: "Player 2")
        )
        let viewModel = GameViewModel(gameModel: model, isColorBlindModeEnabled)

        return GameView(
            gameViewModel: viewModel,
            cardViewBuilder: CardViewBuilder()
        )
    }
}
