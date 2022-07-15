import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder

    var body: some View {
            VStack {
                AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
                    cardViewBuilder.build(for: card)
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: Button(action: {
                        gameViewModel.dealThreeMoreCards()
                    }, label: {
                        Text("Deal 3 more cards")
                    }),
                    trailing: Button(action: {
                        gameViewModel.createNewGame()
                    }, label: {
                        Text("New game")
                    }))
            }
        }
}

// struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetGameView(gameViewModel: SetGameViewModel(deckBuilder: DeckBuilder()))
//    }
// }
