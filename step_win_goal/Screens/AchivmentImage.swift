import SwiftUI

struct AchivmentImage: View {
    var backgroundImage: Image
    var overlayImage: Image
    //var overlaySize: CGSize
   // var overlayOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            backgroundImage
                .resizable()
                .scaledToFit()
                .scaleEffect(-0.8)
                //.scaledToFit() // или .scaledToFill() в зависимости от ваших требований
            
            overlayImage
                .scaleEffect(2)
                //.frame(width: overlaySize.width, height: overlaySize.height)
                //.offset(x: overlayOffset.width, y: overlayOffset.height)
        }
    }
}

