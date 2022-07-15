import Foundation

class GameViewBuilder {
    func build() -> GameView {
        
        let deckBuilder = DeckBuilder()
        let model = GameModel(deckBuilder.createDeck())
        let viewModel = GameViewModel(gameModel: model)
        
        return GameView(
            gameViewModel: viewModel,
            cardViewBuilder: CardViewBuilder()
        )
    }
}
