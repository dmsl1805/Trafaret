//
//  ContentView.swift
//  Aoo
//
//  Created by Dmitriy Yurievich on 28.06.2023.
//

import SwiftUI

/// Enhances failure messages with a command line diff tool expression that can be copied and pasted into a terminal.
///
///     diffTool = "ksdiff"
public var diffTool: String? = nil

struct ContentView: SwiftUI.View {
    var body: some SwiftUI.View {
        ZStack {
            VStack(spacing: 10) {
                SwiftUI.Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
//
                Text("Hello, world!")
//                    .padding(12)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .foregroundColor(.blue)
            }
            
//            VStack(spacing: 10) {
//                SwiftUI.Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//
//                Text("Hello, world!")
//                    .frame(maxWidth: .infinity)
//            }
        }

        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color.red
        )
    }
}





//struct ContentViewSucces: Trafaret {
//    var content: some SwiftUI.View {
//        ContentView()
//    }
//}
//
//
//struct ContentViewFailure: Trafaret {
//    var content: some SwiftUI.View {
//        ContentView()
//    }
//}

import Trafaret

struct ContentView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            ContentView()
                .trafaret(on: .iPhone13)
            
//            ContentViewFailure()
        }
    }
}

//extension SwiftUI.View {
//    @ViewBuilder
//    func recordAsTrafaret(
//        on viewConfig: ViewImageConfig,
//        named name: String? = nil,
//        file: StaticString = #file,
//        snapshotDirectory: String? = nil
//    ) -> some SwiftUI.View {
//        let _ = recordAsTrafaret(
//            content: self,
//            named: name,
//            file: file,
//            snapshotDirectory: snapshotDirectory,
//            viewConfig: viewConfig
//        )
//
//        self
//    }
//
//    @ViewBuilder
//    func trafaret(
//        on viewConfig: ViewImageConfig,
//        named name: String? = nil,
//        file: StaticString = #file,
//        snapshotDirectory: String? = nil,
//        gridsOnEach: Int? = nil
//    ) -> some SwiftUI.View {
//        let result = snapshot(
//            content: self,
//            named: name,
//            file: file,
//            snapshotDirectory: snapshotDirectory,
//            viewConfig: viewConfig
//        )
//
//        Group {
//            self
//                .previewDevice(
//                    PreviewDevice(stringLiteral: "iPhone 13")
//                )
//
//            if let result {
//                self
//                    .overlay {
//                        if let gridsOnEach {
//                            ZStack {
//                                let size = viewConfig.size ?? .zero
//
//                                VStack(spacing: CGFloat(gridsOnEach)) {
//                                    let gridsCount = Int(size.height) / gridsOnEach
//
//                                    ForEach(0...gridsCount, id:  \.self) { _ in
//                                        Color.black
//                                            .frame(maxWidth: .infinity)
//                                            .frame(height: 1)
//                                            .offset(y: 0.5)
//                                    }
//                                }
//
//                                HStack(spacing: CGFloat(gridsOnEach)) {
//                                    let gridsCount = Int(size.width) / gridsOnEach
//
//                                    ForEach(0...gridsCount, id:  \.self) { _ in
//                                        Color.black
//                                            .frame(maxHeight: .infinity)
//                                            .frame(width: 1)
//                                            .offset(x: 0.5)
//                                    }
//                                }
//                            }
//                            .edgesIgnoringSafeArea(.all)
//
//                        }
//                    }
//                    .overlay {
//                        SwiftUI.Image.init(uiImage: result.trafaret)
//                            .edgesIgnoringSafeArea(.all)
//                            .opacity(0.3)
//                    }
//                    .previewDevice(
//                        PreviewDevice(stringLiteral: "iPhone 13")
//                    )
//                    .previewDisplayName("Trafaret")
//
//                self
//                    .overlay {
//                        SwiftUI.Image.init(uiImage: result.diff)
//                            .edgesIgnoringSafeArea(.all)
//                    }
//                    .previewDevice(
//                        PreviewDevice(stringLiteral: "iPhone 13")
//                    )
//                    .previewDisplayName("Diff")
//            }
//        }
//    }
//
//    private func recordAsTrafaret(
//        content: Self,
//        named name: String?,
//        file: StaticString,
//        snapshotDirectory: String?,
//        viewConfig: ViewImageConfig
//    ) {
//
//        var viewConfig = viewConfig
//        viewConfig.traits = .init()
//        let snapshotting: Snapshotting<UIViewController, UIImage> = .image(on: viewConfig)
//
//        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
//        let fileName = fileUrl.deletingPathExtension().lastPathComponent
//
//        let snapshotDirectoryUrl = snapshotDirectory.map { URL(fileURLWithPath: $0, isDirectory: true) }
//        ?? fileUrl
//            .deletingLastPathComponent()
//            .appendingPathComponent("__Snapshots__")
//            .appendingPathComponent(fileName)
//
//        let snapshotFileUrl = snapshotDirectoryUrl
//            .appendingPathExtension("png")
//
//        let fileManager = FileManager.default
//        try? fileManager.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true)
//
//        var diffable: UIImage?
//
//        snapshotting.snapshot(
//            UIHostingController(rootView: content)
//        ).run { b in
//            diffable = b
//        }
//
//        guard let diffable else {
//            return
//        }
//
//        try? snapshotting.diffing.toData(diffable).write(to: snapshotFileUrl)
//    }
//
//    private func snapshot(
//        content: Self,
//        named name: String?,
//        file: StaticString,
//        snapshotDirectory: String?,
//        viewConfig: ViewImageConfig
//    ) -> (trafaret: UIImage, diff: UIImage)? {
//        do {
//            var viewConfig = viewConfig
//            viewConfig.traits = .init()
//            let snapshotting: Snapshotting<UIViewController, UIImage> = .image(on: viewConfig)
//
//            let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
//            let fileName = fileUrl.deletingPathExtension().lastPathComponent
//            print(fileUrl)
//
//            let snapshotDirectoryUrl = snapshotDirectory.map { URL(fileURLWithPath: $0, isDirectory: true) }
//            ?? fileUrl
//                .deletingLastPathComponent()
//                .appendingPathComponent("__Snapshots__")
//                .appendingPathComponent(fileName)
//
//            let snapshotFileUrl = snapshotDirectoryUrl
//                .appendingPathExtension("png")
//
//            let fileManager = FileManager.default
//            try fileManager.createDirectory(at: snapshotDirectoryUrl, withIntermediateDirectories: true)
//
//            //        let tookSnapshot = XCTestExpectation(description: "Took snapshot")
//            var optionalDiffable: UIImage?
//            snapshotting.snapshot(
//                UIHostingController(rootView: content)
//            ).run { b in
//                optionalDiffable = b
//                //          tookSnapshot.fulfill()
//            }
//            //            let result = XCTWaiter.wait(for: [tookSnapshot], timeout: timeout)
//            //            switch result {
//            //            case .completed:
//            //                break
//            //            case .timedOut:
//            //                return """
//            //            Exceeded timeout of \(timeout) seconds waiting for snapshot.
//            //
//            //            This can happen when an asynchronously rendered view (like a web view) has not loaded. \
//            //            Ensure that every subview of the view hierarchy has loaded to avoid timeouts, or, if a \
//            //            timeout is unavoidable, consider setting the "timeout" parameter of "assertSnapshot" to \
//            //            a higher value.
//            //            """
//            //            case .incorrectOrder, .invertedFulfillment, .interrupted:
//            //                return "Couldn't snapshot value"
//            //            @unknown default:
//            //                return "Couldn't snapshot value"
//            //            }
//
//            guard var diffable = optionalDiffable else {
//                //                "Couldn't snapshot value"
//                return nil
//            }
//
////            guard !recording, fileManager.fileExists(atPath: snapshotFileUrl.path) else {
////
////                try snapshotting.diffing.toData(diffable).write(to: snapshotFileUrl)
//////#if !os(Linux) && !os(Windows)
//////                if ProcessInfo.processInfo.environment.keys.contains("__XCODE_BUILT_PRODUCTS_DIR_PATHS") {
//////                    XCTContext.runActivity(named: "Attached Recorded Snapshot") { activity in
//////                        let attachment = XCTAttachment(contentsOfFile: snapshotFileUrl)
//////                        activity.add(attachment)
//////                    }
//////                }
//////#endif
////
//////                return recording
//////                ? """
//////                          Record mode is on. Turn record mode off and re-run "\(testName)" to test against the newly-recorded snapshot.
//////
//////                          open "\(snapshotFileUrl.absoluteString)"
//////
//////                          Recorded snapshot: …
//////                          """
//////                : """
//////                          No reference was found on disk. Automatically recorded snapshot: …
//////
//////                          open "\(snapshotFileUrl.path)"
//////
//////                          Re-run "\(testName)" to test against the newly-recorded snapshot.
//////                          """
////                return nil
////            }
//
//            let data = try Data(contentsOf: snapshotFileUrl)
//            let reference = snapshotting.diffing.fromData(data)
//
//            guard let (failure, attachments) = snapshotting.diffing.diff(reference, diffable) else {
//                return nil
//            }
//
//            let artifactsUrl = URL(
//                fileURLWithPath: ProcessInfo.processInfo.environment["SNAPSHOT_ARTIFACTS"] ?? NSTemporaryDirectory(), isDirectory: true
//            )
//            let artifactsSubUrl = artifactsUrl.appendingPathComponent(fileName)
//            try fileManager.createDirectory(at: artifactsSubUrl, withIntermediateDirectories: true)
//            let failedSnapshotFileUrl = artifactsSubUrl.appendingPathComponent(snapshotFileUrl.lastPathComponent)
//            try snapshotting.diffing.toData(diffable).write(to: failedSnapshotFileUrl)
//
//
//
//
//            guard let first = attachments.first, let last = attachments.last else {
//                return nil
//            }
//            return (first, last)
//        } catch {
//            return nil
//        }
//    }
//}
//
