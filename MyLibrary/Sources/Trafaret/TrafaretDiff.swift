import Foundation
import SwiftUI

public extension SwiftUI.View {
    
    @ViewBuilder
    func trafaret(
        on viewConfig: ViewImageConfig,
        file: StaticString = #file,
        named name: String? = nil,
        in directory: String? = nil,
        gridsOnEach: Int? = nil,
        opacity: CGFloat = 0.3
    ) -> some SwiftUI.View {
        let result = `catch` {
            try Trafaret.diff(
                content: self,
                on: viewConfig,
                file: file,
                named: name,
                in: directory
            )
        }
                
        let _ = print(result)
        
        Group {
            self
                .previewDevice(
                    viewConfig.previewDevice
                )
            
            if case let .success(result) = result, let (trafaret, diff) = result {
                trafaretView(trafaret, viewConfig: viewConfig, opacity: opacity)
                
                diffView(diff, viewConfig: viewConfig)

            } else if case let .failure(error) = result {
                errorView(error)
            }
        }
    }
    
    @ViewBuilder
    private func trafaretView(_ trafaret: UIImage, viewConfig: ViewImageConfig, opacity: CGFloat) -> some SwiftUI.View {
        self
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
            .overlay(
                SwiftUI.Image.init(uiImage: trafaret)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(opacity)
            )
            .previewDevice(
                viewConfig.previewDevice
            )
            .previewDisplayName("Trafaret")
    }
    
    @ViewBuilder
    private func diffView(_ diff: UIImage, viewConfig: ViewImageConfig) -> some SwiftUI.View {
        self
            .overlay(
                SwiftUI.Image.init(uiImage: diff)
                    .edgesIgnoringSafeArea(.all)
            )
            .previewDevice(
                viewConfig.previewDevice
            )
            .previewDisplayName("Diff")
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some SwiftUI.View {
        Text("Error: \(error.localizedDescription)")
            .previewDisplayName("Error")
    }
}

extension Trafaret {
    static func diff<View: SwiftUI.View>(
        content: View,
        on viewConfig: ViewImageConfig,
        file: StaticString,
        named name: String?,
        in directory: String?
    ) throws -> (trafaret: UIImage, diff: UIImage)? {
        var viewConfig = viewConfig
        viewConfig.traits = .init()
        
        let snapshotting: Snapshotting<View, UIImage> = .image(layout: .device(config: viewConfig))
        
        let directoryURL = directoryURL(file: file, named: name, in: directory)
        let fileURL = directoryURL.appendingPNGExtension()
        
        var diffable: UIImage?
        
        snapshotting.snapshot(
            content
        ).run { b in
            diffable = b
        }
        
        guard let diffable else {
            return nil
        }
        
        
        
        let data = try Data(contentsOf: fileURL)
        let reference = snapshotting.diffing.fromData(data)
        
        guard
            let (_, attachments) = snapshotting.diffing.diff(reference, diffable),
            let first = attachments.first,
            let last = attachments.last
        else {
            return nil
        }
        
        return (first, last)
    }
}
