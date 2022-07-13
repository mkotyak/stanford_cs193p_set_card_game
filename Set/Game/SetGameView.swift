import SwiftUI

struct SetGameView: View {
    @ObservedObject var gameViewModel: SetGameViewModel

    var body: some View {
        VStack {
            AspectVGrid(items: gameViewModel.firstSetOfCards, aspectRatio: 2 / 3) { card in
                CardView(cardContent: card.content)
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {
                    print("3 more cards are being added")
                }, label: {
                    Text("Deal 3 more cards")
                }),
                trailing: Button(action: {
                    print("new game is being started")
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
