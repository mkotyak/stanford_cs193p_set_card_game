import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder

    var body: some View {
        ScrollView {
            AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
                cardViewBuilder.build(for: card)
                    .onTapGesture {
                        gameViewModel.selectCard(for: card)
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                gameViewModel.dealThreeMoreCards()
            }, label: {
                Text("+3 cards")
                    .frame(width: 95, height: 37)
                    .background(gameViewModel.moreCardsButtonColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            })
            .disabled(gameViewModel.isMoreCardAvailable),
            trailing: Button(action: {
                gameViewModel.startNewGame()
            }, label: {
                Text("New game")
                    .frame(width: 95, height: 37)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }))
    }
}

// struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetGameView(gameViewModel: SetGameViewModel(deckBuilder: DeckBuilder()))
//    }
// }
