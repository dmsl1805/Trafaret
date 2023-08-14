import Foundation
import SwiftUI

@available(iOS 16.0, *)
public protocol TrafaretSnapshotProvider {
    associatedtype Content: View
    
    static var previewContainer: PreviewContainer { get }
    static var compareConfig: CompareConfig { get }
    static var path: FilePath { get }
    static var testConfig: TestConfig { get }
    
    static var body: Content { get }
}

@available(iOS 16.0, *)
public extension TrafaretSnapshotProvider where Self: PreviewProvider {
    static var compareConfig: CompareConfig { .trafaret }

    @MainActor
    @ViewBuilder
    static var previews: some View {
        let _ = `catch` {
            let testCase = TestCase(
                module: testConfig.path.moduleName,
                name: testConfig.path.formattedName,
                viewName: testConfig.path.formattedViewName,
                container: previewContainer,
                perceptualPrecision: testConfig.perceptualPrecision,
                scale: previewContainer.scale
            )
                        
            let fileManager = FileManager.default
            let testFileURL = testConfig.path.testFileURL
            let directoryURL = testFileURL.deletingLastPathComponent()
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

            try testCase.body
                .data(using: .utf8)?
                .write(to: testFileURL)
        }
        
        body
            .trafaret(
                on: previewContainer,
                compareAs: compareConfig,
                path: path
            )
    }
}
