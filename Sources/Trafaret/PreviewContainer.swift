import Foundation
import SwiftUI
import CoreGraphics

public enum PreviewContainer {
    case device(Device)
    case size(CGSize)
    
    public static func size(width: CGFloat, height: CGFloat) -> Self {
        .size(CGSize(width: width, height: height))
    }
    
    var size: CGSize {
        switch self {
        case .device(let device):
            return device.size
        case .size(let size):
            return size
        }
    }
}

extension View {
    @ViewBuilder
    func preview(on container: PreviewContainer) -> some View {
        switch container {
        case .device(let device):
            previewDevice(PreviewDevice(rawValue: device.name))
        case .size(let size):
            previewLayout(.fixed(width: size.width, height: size.height))
        }
    }
}
