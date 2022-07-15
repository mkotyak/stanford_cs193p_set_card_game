import SwiftUI

struct CardView: View {
    @ObservedObject var cardViewModel: CardViewModel

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 15)
            shape.fill(cardViewModel.backroundColor)
            shape.strokeBorder(lineWidth: 2).foregroundColor(cardViewModel.strokeColor)
            VStack {
                /// I get "Non-constant range: argument must be an integer literal" warning
                /// on the 16th line, but don't know how to avoid it
                ForEach(0 ..< cardViewModel.numOfShapes) { _ in
                    Text(cardViewModel.shape)
                    Text(cardViewModel.shading)
                    Text("-----------")
                }
                .font(.system(size: 10))
                .foregroundColor(cardViewModel.contentColor)
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
