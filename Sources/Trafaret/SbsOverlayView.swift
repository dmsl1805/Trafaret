import Foundation
import SwiftUI

@available(iOS 15.0, *)
struct SbsOverlayView<Original: View>: View {
    let content: () -> Original
    
    @State private var location: CGPoint = CGPoint(x: 50, y: 50)
    @GestureState private var startLocation: CGPoint? = nil
    
    init(@ViewBuilder content: @escaping () -> Original) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            content()
                .mask {
                    HStack {
                        Rectangle()
                            .frame(width: location.x - 0.25)
                        
                        Spacer()
                    }
                }
            
            HStack {
                Rectangle()
                    .frame(width: 0.5)
                    .offset(x: location.x - 0.25)

                Spacer()
            }
            
            Circle()
                .foregroundColor(.secondary)
                .frame(width: 44, height: 44)
                .position(location)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            var newLocation = startLocation ?? location
                            newLocation.x += value.translation.width
                            newLocation.y += value.translation.height
                            self.location = newLocation
                        }.updating($startLocation) { (value, startLocation, transaction) in
                            startLocation = startLocation ?? location
                        }
                )
        }
    }
}
