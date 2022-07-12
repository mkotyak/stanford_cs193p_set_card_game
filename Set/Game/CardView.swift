import SwiftUI

struct CardView: View {
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            shape.fill().foregroundColor(.white)
            shape.strokeBorder(lineWidth: 3)
            Image(systemName: "suit.diamond")
                .font(.largeTitle)
        }
        .padding()
    }
}









struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
