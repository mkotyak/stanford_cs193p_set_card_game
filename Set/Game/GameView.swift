import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder

    var body: some View {
        VStack {
            AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
                cardViewBuilder.build(for: card)
                    .onTapGesture {
                        guard let player = gameViewModel.whoseTurn else {
                            return
                        }
                        gameViewModel.select(card, player)
                    }
            }
            .onReceive(gameViewModel.timer) { _ in
                gameViewModel.performCountingDownAction()
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
                    gameViewModel.didSelect(player: gameViewModel.player1)
                } label: {
                    Text("Player 1")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.player1ButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(gameViewModel.player2.id == gameViewModel.whoseTurn?.id)
                Spacer()
                Text("\(gameViewModel.player1.score) - \(gameViewModel.player2.score)")
                    .font(.largeTitle)
                Spacer()
                Button {
                    gameViewModel.didSelect(player: gameViewModel.player1)
                } label: {
                    Text("Player 2")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.player2ButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(gameViewModel.player1.id == gameViewModel.whoseTurn?.id)
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
