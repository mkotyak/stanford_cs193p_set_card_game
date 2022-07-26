import SwiftUI

struct CardView: View {
    private enum Constants {
        static let cornerRadius: CGFloat = 15
        static let borderWidth: CGFloat = 2
        static let shapeImageScale: CGFloat = 0.8
    }

    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
                shape.fill(cardViewModel.backroundColor)
                shape.strokeBorder(lineWidth: Constants.borderWidth)
                    .foregroundColor(cardViewModel.strokeColor)
                VStack {
                    ForEach(0 ..< cardViewModel.numOfShapes, id: \.self) { _ in
                        cardViewModel.shapeImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geometry.size.height, geometry.size.width) * Constants.shapeImageScale)
                    }
                    .foregroundColor(cardViewModel.contentColor)
                }
            }
        }
        .padding()
    }
}
