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
                Text("Score: \(gameViewModel.score)")
                    .bold()
                Spacer()
                discardPileView
            }
            .padding(.horizontal, 30)
        }
        .onDisappear {
            gameViewModel.startNewGame()
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
                let matchStatus = gameViewModel.didSelect(card: card)
                if matchStatus == .successfulMatch {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak gameViewModel] in
                        withAnimation(.easeInOut(duration: 1)) {
                            gameViewModel?.finishTurn(matchStatus: matchStatus)
                        }
                    }
                }
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
        ZStack {
            VStack {
                ZStack {
                    ForEach(0..<gameViewModel.playedCards.count, id: \.self) { index in
                        cardViewBuilder.build(
                            for: gameViewModel.playedCards[index],
                            isColorBlindModeEnabled: gameViewModel.isColorBlindModeEnabled
                        )
                        .stacked(position: index, in: gameViewModel.playedCards.count)
                        .matchedGeometryEffect(id: gameViewModel.playedCards[index].id, in: dealingNamespace)
                    }
                }
                .frame(width: Constants.deckBlockWidth, height: Constants.deckBlockHeight)
                Text("Discard pile").font(.system(size: Constants.deckTextSize))
            }
        }
    }

    private var deckView: some View {
        ZStack {
            VStack {
                ZStack {
                    ForEach(0 ..< gameViewModel.deck.count, id: \.self) { index in
                        cardViewBuilder.build(
                            for: gameViewModel.deck[index],
                            isColorBlindModeEnabled: gameViewModel.isColorBlindModeEnabled
                        )
                        .stacked(position: index, in: gameViewModel.deck.count)
                        .matchedGeometryEffect(id: gameViewModel.deck[index].id, in: dealingNamespace)
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
    }

    private var newGameButton: some View {
        Text("New game")
            .frame(width: Constants.buttonFrameWidth, height: Constants.buttonFrameHeight)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 2)
                    .fill(.blue)
            )
            .foregroundColor(.black)
            .cornerRadius(Constants.buttonCornerRadius)
    }

    private func dealAnimation(for card: CardModel) -> Animation {
        var delay = 0.0
        if let index = gameViewModel.deck.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * 2 / Double(12)
        }
        return Animation.easeInOut(duration: Constants.dealAnimationDuration).delay(delay)
    }
}
