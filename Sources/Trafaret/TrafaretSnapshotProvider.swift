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
struct TrafaretSnapshotView<Content: View>: View {
    let previewContainer: PreviewContainer
    let compareConfig: CompareConfig
    let path: FilePath
    let testConfig: TestConfig
    let content: () -> Content
    
    var body: some View {
        let _ = Self._printChanges()

        let _ = `catch` {
            try createTestCaseIfNeeded()
        }
        
        content()
            .trafaret(
                on: previewContainer,
                compareAs: compareConfig,
                path: path
            )
    }
    
    private func createTestCaseIfNeeded() throws {
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
        
        guard !fileManager.fileExists(atPath: testFileURL.path()) else {
            return
        }
        
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        try testCase.body
            .data(using: .utf8)?
            .write(to: testFileURL)
    }
}

@available(iOS 16.0, *)
public extension TrafaretSnapshotProvider where Self: PreviewProvider {
    static var compareConfig: CompareConfig { .trafaret }

    @MainActor
    @ViewBuilder
    static var previews: some View {
        TrafaretSnapshotView(
            previewContainer: previewContainer,
            compareConfig: compareConfig,
            path: path,
            testConfig: testConfig
        ) {
            body
        }
    }
}
