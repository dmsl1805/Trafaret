//
//  AooTests.swift
//  AooTests
//
//  Created by Dmitriy Yurievich on 28.06.2023.
//

import SwiftUI
import XCTest
import SnapshotTesting
@testable import Aoo

final class AooTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        SnapshotTesting.diffTool = "ksdiff"
        
        let fileUrl = URL(fileURLWithPath: "\(#file)", isDirectory: true)
        let fileName = fileUrl.deletingPathExtension().lastPathComponent
        print(fileUrl)
        
        let snapshotDirectoryUrl = fileUrl
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Aoo")
            .appendingPathComponent("__Snapshots__")
//            .appendingPathComponent("ContentView.png")

        var viewConfig = SnapshotTesting.ViewImageConfig.iPhone13
        viewConfig.traits = .init()
        
        let failure = verifySnapshot(
            matching: UIHostingController(rootView: ContentViewSucces().content),
            as: .image(on: viewConfig),
            named: "",
            snapshotDirectory: snapshotDirectoryUrl.relativePath,
            testName: "ContentView"
        )
//        let failure = verifySnapshot(
//            matching: UIHostingController(rootView: ContentView()),
//            as: .image(on: .iPhone13)
//        )

        if let failure {
            XCTFail(failure)
        }
        
//        assersna
    }

}
// "file:///Users/dmsl/Desktop/Rounding/AooTests/__Snapshots__/AooTests/"

//(Foundation.URL) snapshotDirectoryUrl = "file:/Users/dmsl/Desktop/Rounding/Aoo/__Snapshots__/ -- file:///"
