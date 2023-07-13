import Foundation
import SwiftUI

public extension SwiftUI.View {
    @ViewBuilder
    func recordAsTrafaret(
        on viewConfig: ViewImageConfig,
        file: StaticString = #file,
        named name: String? = nil,
        in directory: String? = nil
    ) -> some SwiftUI.View {
        let error = `catch` {
            try Trafaret.record(
                content: self,
                on: viewConfig,
                file: file,
                named: name,
                in: directory
            )
        }
        
        if let error {
            Text("Error: \(error.localizedDescription)")
        } else {
            self
        }
    }
}

enum Trafaret {
    static func record<View: SwiftUI.View>(
        content: View,
        on viewConfig: ViewImageConfig,
        file: StaticString,
        named name: String?,
        in directory: String?
    ) throws {
        var viewConfig = viewConfig
        viewConfig.traits = UITraitCollection()
        
        let snapshotting: Snapshotting<View, UIImage> = .image(layout: .device(config: viewConfig))
        
        let directoryURL = directoryURL(file: file, named: name, in: directory)
        let fileURL = directoryURL.appendingPNGExtension()
        
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        
        var diffable: UIImage?
        
        snapshotting.snapshot(
            content
        ).run { b in
            diffable = b
        }
        
        if let diffable {
            try snapshotting.diffing.toData(diffable).write(to: fileURL)
        }
    }
}
