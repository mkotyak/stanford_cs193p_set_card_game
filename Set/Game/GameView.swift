import SwiftUI

struct GameView: View {
    private enum Constants {
        static let buttonFrameWidth: CGFloat = 95
        static let buttonFrameHeight: CGFloat = 30
        static let buttonCornerRadius: CGFloat = 10
    }

    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder

    var body: some View {
        VStack {
            AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
                cardViewBuilder.build(for: card, gameViewModel.isColorBlindModeEnabled)
                    .onTapGesture {
                        gameViewModel.didSelect(card: card)
                    }
            }
            .navigationTitle("\(gameViewModel.timerTitle)")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: Button {
                    gameViewModel.dealThreeMoreCards()
                } label: {
                    threeMoreCardsButton
                }
                .disabled(gameViewModel.isMoreCardAvailable),

                trailing: Button {
                    gameViewModel.startNewGame()
                } label: {
                    newGameButton
                })

            HStack {
                Button {
                    gameViewModel.didSelect(player: gameViewModel.firstPlayer)
                } label: {
                    firstPlayerButton
                }
                .disabled(gameViewModel.isSecondPlayerActive)

                Spacer()
                Text("\(gameViewModel.firstPlayer.score) - \(gameViewModel.secondPlayer.score)")
                    .font(.largeTitle)
                Spacer()

                Button {
                    gameViewModel.didSelect(player: gameViewModel.secondPlayer)
                } label: {
                    secondPlayerButton
                }
                .disabled(gameViewModel.isFirstPlayerActive)
            }
            .padding()
        }
    }

    var threeMoreCardsButton: some View {
        Text("+3 cards")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(gameViewModel.moreCardsButtonColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    var newGameButton: some View {
        Text("New game")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    var firstPlayerButton: some View {
        Text("\(gameViewModel.firstPlayer.name)")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(gameViewModel.firstPlayerButtonColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    var secondPlayerButton: some View {
        Text("\(gameViewModel.secondPlayer.name)")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(gameViewModel.secondPlayerButtonColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }
}
