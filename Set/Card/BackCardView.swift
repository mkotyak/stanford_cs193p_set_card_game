import SwiftUI

struct BackCardView: View {
    enum Constants {
        static let cornerRadius: CGFloat = 15
    }

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            shape.fill(.white)
            shape.strokeBorder(lineWidth: 2)
                .foregroundColor(.black)
            Text("Set").foregroundColor(.green)
        }
    }
}
