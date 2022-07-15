import SwiftUI

struct StartGameView: View {
    let gameViewBuilder: GameViewBuilder
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: gameViewBuilder.build()) {
                Text("Start the game")
                    .font(.largeTitle)
                    .frame(width: 280, height: 55)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 120)
        }
    }
}








//struct StartGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartGameView()
//    }
//}
