import SwiftUI

struct GameView: View {
    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder
    
    @State var countDownTimer = 10
    @State var isRunning = false
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
            .navigationTitle(Text("Timer: \(countDownTimer)"))
            .onReceive(timer) { _ in
                if countDownTimer >= 1 && isRunning {
                    countDownTimer -= 1
                } else if countDownTimer == 0 {
                    isRunning = false
                    countDownTimer = 10
                }
            }
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
                    isRunning = true
                    gameViewModel.whoseTurn = gameViewModel.player1
                } label: {
                    Text("Player 1")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.moreCardsButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Spacer()
                Text("\(gameViewModel.player1.score) - \(gameViewModel.player2.score)")
                    .bold()
                    .font(.largeTitle)
                Spacer()
                Button {
                    isRunning = true
                    gameViewModel.whoseTurn = gameViewModel.player2
                } label: {
                    Text("Player 2")
                        .frame(width: 95, height: 30)
                        .background(gameViewModel.moreCardsButtonColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
