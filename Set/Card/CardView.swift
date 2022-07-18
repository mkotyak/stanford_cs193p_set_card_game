import SwiftUI

struct CardView: View {
    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 15)
                shape.fill(cardViewModel.backroundColor)
                shape.strokeBorder(lineWidth: 2).foregroundColor(cardViewModel.strokeColor)
                VStack {
                    ForEach(0 ..< cardViewModel.numOfShapes) { _ in
                        cardViewModel.shape
                            .resizable()
                            .scaledToFit()
                            .frame(width: min(geometry.size.height, geometry.size.width) * 0.8)
                    }
                    .foregroundColor(cardViewModel.contentColor)
                }
            }
        }
        .padding()
    }
}

// struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView()
//    }
// }
