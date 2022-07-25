import Foundation

class GameViewBuilder {
    func build() -> GameView {
        
        let deckBuilder = DeckBuilder()
        let model = GameModel(deckBuilder: deckBuilder, firstPlayer: Player(name: "Player 1"), secondPlayer: Player(name: "Player 2"))
        let viewModel = GameViewModel(gameModel: model)
        
        return GameView(
            gameViewModel: viewModel,
            cardViewBuilder: CardViewBuilder()
        )
    }
}
