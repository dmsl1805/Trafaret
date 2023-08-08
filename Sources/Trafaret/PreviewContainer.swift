import Foundation
import SwiftUI
import CoreGraphics

public enum PreviewContainer {
    case device(Device, scale: CGFloat = 1)
    case size(CGSize, scale: CGFloat = 1)
        
    public static func size(width: CGFloat, height: CGFloat, scale: CGFloat = 1) -> Self {
        .size(CGSize(width: width, height: height), scale: scale)
    }
    
    var size: CGSize {
        switch self {
        case .device(let device, _):
            return device.size
        case .size(let size, _):
            return size
        }
    }
    
    var scale: CGFloat {
        switch self {
        case .device(_, let scale), .size(_, let scale):
            return scale
        }
    }
}

extension View {
    @ViewBuilder
    func preview(on container: PreviewContainer) -> some View {
        switch container {
        case .device(let device, _):
            previewDevice(PreviewDevice(rawValue: device.name))
        case .size(let size, _):
            previewLayout(.fixed(width: size.width, height: size.height))
        }
    }
}
