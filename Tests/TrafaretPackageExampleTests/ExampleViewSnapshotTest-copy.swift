import XCTest
import SnapshotTesting
import SwiftUI
import TrafaretPackageExample

//final class ExampleViewSnapshotTestCop: XCTestCase {
//    func test() {
//        var config = ViewImageConfig.iPhone13
//        config.traits = .init()
//        
//        let message = verifySnapshot(
//            matching: UIHostingController(rootView: ExampleViewPreview.body),
//            as: .image(on: config, precision: 0.9),
//            originalFileName: "ExampleView",
//            snapshotDirectory: ExampleViewPreview.testConfig.path.trafaretFileURL.deletingLastPathComponent().absoluteString
//        )
//        
//        guard let message else { return }
//        XCTFail(message)
//    }
//}


import XCTest
import SnapshotTesting
import SwiftUI
import TrafaretPackageExample

final class ExampleViewSnapshotTestCopy: XCTestCase {
    func test() {
        var config = ViewImageConfig.iPhone12
        config.traits = .init()
        
        let viewController = UIHostingController(rootView: ExampleViewPreview.body)
        viewController.view.frame = CGRect(origin: .zero, size: config.size ?? .zero)
                
        let message = verifySnapshot(
            matching: viewController,
            as: .image(on: config, perceptualPrecision: 0.9, traits: UITraitCollection(displayScale: 3)),
            originalFileName: "ExampleView",
            snapshotDirectory: ExampleViewPreview.testConfig.path.trafaretFileURL.deletingLastPathComponent().absoluteString
        )

        guard let message else { return }
        XCTFail(message)
    }
}
