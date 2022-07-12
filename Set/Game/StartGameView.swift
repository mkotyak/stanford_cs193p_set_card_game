import SwiftUI

struct StartGameView: View {
    var body: some View {
        NavigationView {
            NavigationLink(destination: SetGameView(gameViewModel: SetGameViewModel())) {
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
