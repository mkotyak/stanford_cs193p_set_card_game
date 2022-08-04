import SwiftUI

struct GameView: View {
    private enum Constants {
        static let buttonFrameWidth: CGFloat = 95
        static let buttonFrameHeight: CGFloat = 30
        static let buttonCornerRadius: CGFloat = 10
        static let discardPileBlockWidth: CGFloat = 50
        static let discardPileBlockHeight: CGFloat = 80
        static let discardPileBlockCornerRadius: CGFloat = 15
        static let discardPileBlockBorderLines: CGFloat = 2
        static let deckBlockWidth: CGFloat = 60
        static let deckBlockHeight: CGFloat = 90
        static let deckTextSize: CGFloat = 10
        static let defaultCardsOnScreenCount: Int = 12
        static let cardsToDealCount: Int = 3
        static let dealAnimationDuration: Double = 0.5
    }

    @ObservedObject var gameViewModel: GameViewModel
    let cardViewBuilder: CardViewBuilder
    @Namespace private var dealingNamespace

    var body: some View {
        VStack {
            gameBodyView
            HStack {
                deckView
                Spacer()
                // code for the solo version of the game >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                Text("Score: \(gameViewModel.score)")
                    .bold()
                // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                Spacer()
                discardPileView
            }
            .padding(.horizontal, 30)

//            HStack {
//                Button {
//                    gameViewModel.didSelect(player: gameViewModel.firstPlayer)
//                } label: {
//                    firstPlayerButton
//                }
//                .disabled(gameViewModel.isSecondPlayerActive)
//
//                Spacer()
//                Text("\(gameViewModel.firstPlayer.score) - \(gameViewModel.secondPlayer.score)")
//                    .font(.largeTitle)
//                Spacer()
//
//                Button {
//                    gameViewModel.didSelect(player: gameViewModel.secondPlayer)
//                } label: {
//                    secondPlayerButton
//                }
//                .disabled(gameViewModel.isFirstPlayerActive)
//            }
//            .padding()
        }
        .navigationTitle("\(gameViewModel.timerTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button {
                gameViewModel.startNewGame()
                for i in 0 ..< Constants.defaultCardsOnScreenCount {
                    withAnimation(dealAnimation(for: gameViewModel.deck[i])) {
                        gameViewModel.deal(card: gameViewModel.deck[i])
                    }
                }
            } label: {
                newGameButton
            }
        )
    }

    private var gameBodyView: some View {
        AspectVGrid(items: gameViewModel.cardsOnScreen, aspectRatio: 2 / 3) { card in
            cardViewBuilder.build(
                for: card,
                isColorBlindModeEnabled: gameViewModel.isColorBlindModeEnabled
            )
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .onTapGesture {
                gameViewModel.didSelect(card: card)
            }
        }
        .onAppear {
            for i in 0 ..< Constants.defaultCardsOnScreenCount {
                withAnimation(dealAnimation(for: gameViewModel.deck[i])) {
                    gameViewModel.deal(card: gameViewModel.deck[i])
                }
            }
        }
    }

    private var discardPileView: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: Constants.discardPileBlockCornerRadius)
                    .strokeBorder(lineWidth: Constants.discardPileBlockBorderLines)
                    .frame(
                        width: Constants.discardPileBlockWidth,
                        height: Constants.discardPileBlockHeight
                    )
            }
            Text("Discard pile").font(.system(size: Constants.deckTextSize))
        }
    }

    private var deckView: some View {
        VStack {
            ZStack {
                ForEach(gameViewModel.deck) { card in
                    cardViewBuilder.build(
                        for: card,
                        isColorBlindModeEnabled: gameViewModel.isColorBlindModeEnabled
                    )
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                }
            }
            .onTapGesture {
                for i in 0 ..< Constants.cardsToDealCount {
                    withAnimation(dealAnimation(for: gameViewModel.deck[i])) {
                        gameViewModel.deal(card: gameViewModel.deck[i])
                    }
                }
            }
            .disabled(gameViewModel.isMoreCardAvailable)
            .frame(width: Constants.deckBlockWidth, height: Constants.deckBlockHeight)
            Text("Deck").font(.system(size: Constants.deckTextSize))
        }
    }

    private var threeMoreCardsButton: some View {
        Text("+3 cards")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(gameViewModel.moreCardsButtonColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    private var newGameButton: some View {
        Text("New game")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    private func dealAnimation(for card: CardModel) -> Animation {
        var delay = 0.0
        if let index = gameViewModel.deck.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * 2 / Double(12)
        }
        return Animation.easeInOut(duration: Constants.dealAnimationDuration).delay(delay)
    }

//    private var firstPlayerButton: some View {
//        Text("\(gameViewModel.firstPlayer.name)")
//            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
//            .background(gameViewModel.firstPlayerButtonColor)
//            .foregroundColor(.white)
//            .cornerRadius(Constants.buttonCornerRadius)
//    }
//
//    private var secondPlayerButton: some View {
//        Text("\(gameViewModel.secondPlayer.name)")
//            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
//            .background(gameViewModel.secondPlayerButtonColor)
//            .foregroundColor(.white)
//            .cornerRadius(Constants.buttonCornerRadius)
//    }
}
