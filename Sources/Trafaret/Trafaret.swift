import Foundation
import SwiftUI
import CoreGraphics



struct TestCase {
    enum Marker: String {
        case module
        case testCase
        case testName
        case viewName
        case viewConfig
        case perceptualPrecision
        
        var markerValue: String { "<-\(rawValue)->" }
    }
    
    private let template = """
    import XCTest
    import SnapshotTesting
    import SwiftUI
    import \(Marker.module.markerValue)
    
    final class \(Marker.testCase.markerValue): XCTestCase {
        func test\(Marker.testName.markerValue)() {
            assertSnapshot(matching: UIHostingController(rootView: \(Marker.viewName.markerValue)()), as: .image(on: \(Marker.viewConfig.markerValue), perceptualPrecision: \(Marker.perceptualPrecision.markerValue))
        }
    }
    """
    
    
}

public enum FilePath {
    case defaultFile(StaticString)
    case custom(name: String, directory: String, fileExtension: String? = nil)
    
    public static func custom(
        file: StaticString = #file,
        named: String? = nil,
        extension fileExtension: String? = nil,
        in directory: String? = nil
    ) -> Self {
        .custom(
            name: named ?? "\(file)",
            directory: directory ?? Self.defaultFile(file).fileURL.deletingLastPathComponent().absoluteString,
            fileExtension: fileExtension
        )
    }
    
    var formattedName: String {
        switch self {
        case let .defaultFile(file):
            let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
            return fileURL.deletingPathExtension().lastPathComponent
            
        case let .custom(name, _, _):
            return name
        }
    }
    
    var trafaretImage: UIImage? {
        get throws {
            UIImage(data: try Data(contentsOf: trafaretFileURL))
        }
    }
    
    var fileManager: FileManager { .default }

    var trafaretFileURL: URL {
        let defaultFileExtension = "png"
        
        switch self {
        case let .defaultFile(file):
            let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
            let fileName = fileURL.deletingPathExtension().lastPathComponent
            
            return fileURL
                .deletingLastPathComponent()
                .appendingPathComponent("__Trafarets__")
                .appendingPathComponent(fileName)
                .appendingPathExtension(defaultFileExtension)

        case let .custom(name, directory, fileExtension):
            return URL(fileURLWithPath: directory, isDirectory: true)
                .appendingPathComponent(name)
                .appendingPathExtension(fileExtension ?? defaultFileExtension)
        }
    }
    
    var testFileURL: URL {
        let defaultFileExtension = "swift"
        
        switch self {
        case let .defaultFile(file):
            let fileURL = URL(fileURLWithPath: "\(file)", isDirectory: false)
            let fileName = fileURL.deletingPathExtension().lastPathComponent
            
            return fileURL
                .deletingLastPathComponent()
                .appendingPathComponent("__Trafarets__")
                .appendingPathComponent(fileName)
                .appendingPathExtension(defaultFileExtension)

        case let .custom(name, directory, _):
            return URL(fileURLWithPath: directory, isDirectory: true)
                .appendingPathComponent(name)
                .appendingPathExtension(fileExtension ?? defaultFileExtension)
        }
    }
}

public struct TestConfig {
    let path: FilePath
    let module: String
    let name: String
//    let
//    let moduleMarker = "<—module—>"
//    let testCaseMarker = "<—test-case—>"
//    let testMarker = "<—test—>"
//    let viewMarker = "<—view—>"
//    let viewConfigMarker = "<—view—config->"
//    let perceptualPrecisionMarker = "<—perceptual-precision->"
}

@available(iOS 16.0, *)
public protocol TrafaretSnapshot {
    associatedtype Content: View
    
    static var previewContainer: PreviewContainer { get }
    static var compareConfig: CompareConfig { get }
    static var path: FilePath { get }
    
    static var body: Content { get }
}

@available(iOS 16.0, *)
public extension TrafaretSnapshot where Self: PreviewProvider {
    static var compareConfig: CompareConfig { .trafaret }
    
    @MainActor
    @ViewBuilder
    static var previews: some View {
        let result = `catch` {
            let fileManager = FileManager.default
            let directoryURL = path.fileURL.deletingLastPathComponent()
            let fileURL = directoryURL.appendingPathComponent("TestName").appendingPathExtension("swift")

            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            print(fileURL)
            try testTemplate
//                .replacingOccurrences(of: <#T##StringProtocol#>, with: <#T##StringProtocol#>)
                .data(using: .utf8)?
                .write(to: fileURL)
        }
        
        let _ = print(result)
        
        body
            .trafaret(
                on: previewContainer,
                compareAs: compareConfig,
                path: path
            )
    }
}

@available(iOS 16.0, *)
public extension View {
    @MainActor
    @ViewBuilder
    func trafaret(
        on container: PreviewContainer,
        compareAs config: CompareConfig = .trafaret,
        path: FilePath
    ) -> some View {
        let previewName = path.formattedName
        
        let result = `catch` {
            try path.trafaretImage
        }
                                
        Group {
            self
                .preview(on: container)
                .previewDisplayName(previewName)

            if case let .success(result) = result, let (trafaretImage) = result {
                switch config.mode {
                case .trafaret:
                    trafaretView(trafaretImage, container: container, config: config, name: previewName)
                    
                case .sideBySide:
                    sideBySideView(trafaretImage, container: container, config: config, name: previewName)
                }
                
                if trafaretImage.size != container.size {
                    errorView(
                        """
                        Provided image and container sizes are differen.
                        Image: \(trafaretImage.size)
                        Device: \(container.size)
                        """,
                        name: previewName
                    )
                    
                } else if config.isDiffingEnabled,
                          let actualImage = image(size: container.size) {
                    let diff = diff(trafaretImage, actualImage)
                    diffImageView(diff, container: container, name: previewName)
                    
                } else {
                    errorView("No image was rendered", name: previewName)
                }
                
            } else if case let .failure(error) = result {
                let fileURL = path.fileURL

                errorView(
                    """
                    \(error.localizedDescription)
                    File: \(fileURL)
                    """,
                    name: previewName
                )
            }
        }
    }
    
    @ViewBuilder
    private func trafaretView(
        _ trafaret: UIImage,
        container: PreviewContainer,
        config: CompareConfig,
        name: String
    ) -> some View {
        self
            .overlay(
                Image.init(uiImage: trafaret)
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(config.opacity)
            )
            .overlay(
                grids(onEach: config.gridsOnEach)
            )
            .preview(on: container)
            .previewDisplayName("\(name) Trafaret")
    }
    
    @ViewBuilder
    private func sideBySideView(
        _ trafaret: UIImage,
        container: PreviewContainer,
        config: CompareConfig,
        name: String
    ) -> some View {
        self
            .overlay(
                SbsOverlayView {
                    Image.init(uiImage: trafaret)
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .opacity(config.opacity)
                }
                    .edgesIgnoringSafeArea(.all)
            )
            .overlay(
                grids(onEach: config.gridsOnEach)
            )
            .preview(on: container)
            .previewDisplayName("\(name) Trafaret")
    }
    
    @ViewBuilder
    private func grids(onEach spacing: Int?) -> some View {
        if let spacing {
            GeometryReader { proxy in
                let horizontalGridsCount = Int(proxy.size.width) / spacing
                let verticalGridsCount = Int(proxy.size.height) / spacing
                let lineWidth: CGFloat = 1 / UIScreen.main.scale

                ZStack(alignment: .topLeading) {
                    ForEach(0...horizontalGridsCount, id:  \.self) { index in
                        Color.black
                            .frame(maxHeight: .infinity)
                            .frame(width: lineWidth)
                            .offset(
                                x: CGFloat(index * spacing)
                                - proxy.size.width / 2
                                + lineWidth / 2
                            )
                    }
                    .frame(maxWidth: .infinity)

                    ForEach(0...verticalGridsCount, id:  \.self) { index in
                        Color.black
                            .frame(maxWidth: .infinity)
                            .frame(height: lineWidth)
                            .offset(
                                y: CGFloat(index * spacing)
                                - proxy.size.height / 2
                                + lineWidth / 2
                            )
                    }
                    .frame(maxHeight: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    private func diffImageView(_ image: UIImage, container: PreviewContainer, name: String) -> some View {
        Image(uiImage: image)
            .preview(on: container)
            .previewDisplayName("\(name) Diff")
    }
    
    @ViewBuilder
    private func errorView(_ description: String, name: String) -> some View {
        Text("Error: \(description)")
            .previewDisplayName("\(name) Error")
    }
    
    @MainActor
    private func image(size: CGSize) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.proposedSize = .init(size)
        return renderer.uiImage
    }
    
    private func diff(_ old: UIImage, _ new: UIImage) -> UIImage {
        let width = max(old.size.width, new.size.width)
        let height = max(old.size.height, new.size.height)
        let scale = max(old.scale, new.scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, scale)
        new.draw(at: .zero)
        old.draw(at: .zero, blendMode: .difference, alpha: 1)
        let differenceImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return differenceImage
    }
}
