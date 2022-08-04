import SwiftUI

struct CardView: View {
    private enum Constants {
        static let cardsPadding: CGFloat = 5
    }

    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if cardViewModel.cardIsFaceUp {
                    FaceCardView(
                        backgroundColor: cardViewModel.backroundColor,
                        strokeColor: cardViewModel.strokeColor,
                        contentColor: cardViewModel.contentColor,
                        isColorBlindModeEnabled: cardViewModel.isColorBlindModeEnabled,
                        numOfShapes: cardViewModel.numOfShapes,
                        shapeImage: cardViewModel.shapeImage,
                        contentColorDefinition: cardViewModel.contentColorDefinition
                    )
                } else {
                    BackCardView()
                }
            }
        }
        .padding(.all, Constants.cardsPadding)
    }
}
