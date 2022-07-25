import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder

    var body: some View {
        VStack {
            AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
                cardViewBuilder.build(for: card)
                    .onTapGesture {
                        gameViewModel.didSelect(card: card)
                    }
            }
            .navigationTitle("\(gameViewModel.timerTitle)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button(action: {
                    gameViewModel.dealThreeMoreCards()
                }, label: {
                    Text("+3 cards")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.moreCardsButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                })
                .disabled(gameViewModel.isMoreCardAvailable),
                trailing: Button(action: {
                    gameViewModel.startNewGame()
                }, label: {
                    Text("New game")
                        .frame(width: 95, height: 30)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }))
            HStack {
                Button {
                    gameViewModel.didSelect(player: gameViewModel.firstPlayer)
                } label: {
                    Text("\(gameViewModel.firstPlayer.name)")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.player1ButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(gameViewModel.isPlayer2Active)
                Spacer()
                Text("\(gameViewModel.firstPlayer.score) - \(gameViewModel.secondPlayer.score)")
                    .font(.largeTitle)
                Spacer()
                Button {
                    gameViewModel.didSelect(player: gameViewModel.secondPlayer)
                } label: {
                    Text("\(gameViewModel.secondPlayer.name)")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.player2ButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(gameViewModel.isPlayer1Active)
            }
            .padding()
        }
    }
}

// struct GameView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetGameView(gameViewModel: SetGameViewModel(deckBuilder: DeckBuilder()))
//    }
// }
