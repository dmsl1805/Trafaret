import Foundation
import SwiftUI
import CoreGraphics

public enum PreviewContainer {
    case device(String)
    case size(CGSize)
    
    public static func size(width: CGFloat, height: CGFloat) -> Self {
        .size(CGSize(width: width, height: height))
    }
}

extension View {
    @ViewBuilder
    func preview(on container: PreviewContainer) -> some View {
        switch container {
        case .device(let string):
            previewDevice(PreviewDevice(rawValue: string))
        case .size(let size):
            previewLayout(.fixed(width: size.width, height: size.height))
        }
    }
}
