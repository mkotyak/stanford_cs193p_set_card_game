import SwiftUI

struct CardView: View {
    private enum Constants {
        static let cardsPadding: CGFloat = 5
        static let shapeImageScale: CGFloat = 0.55
    }

    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ForEach(0 ..< cardViewModel.numOfShapes, id: \.self) { _ in
                    cardViewModel.shapeImage
                        .resizable()
                        .scaledToFit()
                        .frame(width:
                            min(geometry.size.height, geometry.size.width) * Constants.shapeImageScale
                        )
                }
                .foregroundColor(cardViewModel.contentColor)
            }
            .cardify(
                isFaceUp: cardViewModel.cardIsFaceUp,
                backgroundColor: cardViewModel.backroundColor,
                strokeColor: cardViewModel.strokeColor,
                isHinted: cardViewModel.isHinted,
                isColorBlindModeEnabled: cardViewModel.isColorBlindModeEnabled,
                contentColorDefinition: cardViewModel.contentColorDefinition
            )
            .padding(.all, Constants.cardsPadding)
        }
    }
}
