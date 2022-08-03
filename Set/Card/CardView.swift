import SwiftUI

struct CardView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 2
        static let shapeImageScale: CGFloat = 0.55
        static let colorTextTopPadding: CGFloat = 8
        static let colorTextFontSize: CGFloat = 11
        static let cardsPadding: CGFloat = 5
    }

    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                if cardViewModel.cardIsFaceUp {
                    shape.fill(cardViewModel.backroundColor)
                    shape.strokeBorder(lineWidth: Constants.borderWidth)
                        .foregroundColor(cardViewModel.strokeColor)

                    if cardViewModel.isColorBlindModeEnabled {
                        colorBlindBlock
                    }

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
                } else {
                    ZStack {
                        shape.fill(.black)
                        Text("Set").foregroundColor(.green)
                    }
                }
            }
        }
        .padding(.all, Constants.cardsPadding)
    }

    private var colorBlindBlock: some View {
        VStack(alignment: .leading) {
            Text("\(cardViewModel.contentColorDefinition)")
                .font(.system(size: Constants.colorTextFontSize))
            Spacer()
        }
        .padding(.top, Constants.colorTextTopPadding)
    }
}
