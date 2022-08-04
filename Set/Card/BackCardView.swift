import SwiftUI

struct BackCardView: View {
    enum Constants {
        static let cornerRadius: CGFloat = 15
    }
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
        ZStack {
            shape.fill(.black)
            Text("Set").foregroundColor(.green)
        }
    }
}
