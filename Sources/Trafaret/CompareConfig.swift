import Foundation

public struct CompareConfig {
    public enum CompareMode {
        case trafaret
        case sideBySide
    }
    
    let mode: CompareMode
    let gridsOnEach: Int?
    let opacity: CGFloat
    
    public static var trafaret: Self {
        trafaret()
    }
    
    public static func trafaret(gridsOnEach: Int? = nil, opacity: CGFloat = 0.3) -> Self {
        Self(mode: .trafaret, gridsOnEach: gridsOnEach, opacity: opacity)
    }
    
    public static var sideBySide: Self {
        sideBySide()
    }
    
    public static func sideBySide(gridsOnEach: Int? = nil, opacity: CGFloat = 1) -> Self {
        Self(mode: .sideBySide, gridsOnEach: gridsOnEach, opacity: opacity)
    }
}
