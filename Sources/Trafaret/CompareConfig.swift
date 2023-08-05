import Foundation

/// A config for preview compare mode and features.
///
/// There are several `CompareMode`s available.
///
/// For example, `trafaret` mode will show a reference image right above your view:
///
/// ```swift
/// @available(iOS 16.0, *)
/// struct Preview: PreviewProvider {
///     static var previews: some View {
///         MyView()
///             .trafaret(on: .device("iPhone 14"), compareAs: .trafaret)
///     }
/// }
/// ```
///
/// You can also use `sideBySide` mode, it will mask your view with a reference image with zone control:
///
/// ```swift
/// @available(iOS 16.0, *)
/// struct Preview: PreviewProvider {
///     static var previews: some View {
///         MyView()
///             .trafaret(on: .device("iPhone 14"), compareAs: .sideBySide)
///     }
/// }
/// ```
///
/// Note that all of the `CompareMode` options support `grids`, `opacity` and `diffing` adjustments:
/// 
/// ```swift
/// @available(iOS 16.0, *)
/// struct Preview: PreviewProvider {
///     static var previews: some View {
///         MyView()
///             .trafaret(
///                 on: .device("iPhone 14"),
///                 compareAs: .sideBySide(
///                     gridsOnEach: 24,
///                     opacity: 0.3,
///                     isDiffingEnabled: true
///                 )
///             )
///     }
/// }
/// ```
/// ```swift
/// @available(iOS 16.0, *)
/// struct Preview: PreviewProvider {
///     static var previews: some View {
///         MyView()
///             .trafaret(
///                 on: .device("iPhone 14"),
///                 compareAs: .trafaret(
///                     gridsOnEach: 12,
///                     opacity: 0.8,
///                     isDiffingEnabled: false
///                 )
///             )
///     }
/// }
public struct CompareConfig {
    public enum CompareMode {
        case trafaret
        case sideBySide
    }
    
    let mode: CompareMode
    let gridsOnEach: Int?
    let opacity: CGFloat
    let isDiffingEnabled: Bool
    
    public static var trafaret: Self {
        trafaret()
    }
    
    public static func trafaret(
        gridsOnEach: Int? = nil,
        opacity: CGFloat = 0.3,
        isDiffingEnabled: Bool = true
    ) -> Self {
        Self(
            mode: .trafaret,
            gridsOnEach: gridsOnEach,
            opacity: opacity,
            isDiffingEnabled: isDiffingEnabled
        )
    }
    
    public static var sideBySide: Self {
        sideBySide()
    }
    
    public static func sideBySide(
        gridsOnEach: Int? = nil,
        opacity: CGFloat = 1,
        isDiffingEnabled: Bool = true
    ) -> Self {
        Self(
            mode: .sideBySide,
            gridsOnEach: gridsOnEach,
            opacity: opacity,
            isDiffingEnabled: isDiffingEnabled
        )
    }
}
