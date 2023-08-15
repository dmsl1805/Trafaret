import Foundation
import SwiftUI
import CoreGraphics

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
            try path.trafaretImage(scale: container.scale)
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

                if trafaretImage.size.width.truncatingRemainder(dividingBy: container.size.width) != 0 ||
                    trafaretImage.size.height.truncatingRemainder(dividingBy: container.size.height) != 0 {
                    errorView(
                        """
                        Provided image and container sizes are different.
                        Image: \(trafaretImage.size)
                        Device: \(container.size)
                        """,
                        name: previewName
                    )
                    
//                } else if config.isDiffingEnabled,
//                          let actualImage = image(size: trafaretImage.size, scale: container.scale) {
//                    let diff = diff(trafaretImage, actualImage)
//                    diffImageView(diff, container: container, name: previewName)

                } else {
                    errorView("No image was rendered", name: previewName)
                }

            } else if case let .failure(error) = result {
                let fileURL = path.trafaretFileURL

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
                    .opacity(config.opacity)
                    .edgesIgnoringSafeArea(.all)
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
                        .frame(width: container.size.width, height: container.size.height)
                        .opacity(config.opacity)
                        .edgesIgnoringSafeArea(.all)
                }
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
            .resizable()
            .frame(width: container.size.width, height: container.size.height)
            .edgesIgnoringSafeArea(.all)
            .preview(on: container)
            .previewDisplayName("\(name) Diff")
    }
    
    @ViewBuilder
    private func errorView(_ description: String, name: String) -> some View {
        Text("Error: \(description)")
            .previewDisplayName("\(name) Error")
    }
    
    // TODO: Fix renderer
    @MainActor
    private func image(size: CGSize, scale: CGFloat) -> UIImage? {
//        let renderer = ImageRenderer(content: self)
//        renderer.proposedSize = .init(size)
//        renderer.scale = scale
//        return renderer.uiImage
        
        let vc = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        vc.view?.bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer (size: size)
        
        return renderer.image { _ in
            vc.view?.drawHierarchy(in: vc.view.bounds, afterScreenUpdates: true)
        }
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
