import Foundation
import SwiftUI
import UIKit

//public protocol Trafaret: SwiftUI.View {
//    associatedtype ActualViewContent: SwiftUI.View
//
//    var viewConfig: ViewImageConfig { get }
//
//    var content: ActualViewContent { get }
//
//    var name: String? { get }
//
//    var directory: String? { get }
//
//    var isRecording: Bool { get }
//}
//
//public extension Trafaret {
//    var viewConfig: ViewImageConfig {
//        var config = ViewImageConfig.iPhone13
//        config.traits = .init()
//        return config
//    }
//
//    var body: some SwiftUI.View {
//        do {
//            if isRecording {
//                let _ = try record(content: content, named: name, file: <#T##StaticString#>, directory: <#T##String?#>)
//            } else {
//
//            }
//        } catch let error {
//
//        }
//
//        content
//            .trafaret(on: viewConfig, gridsOnEach: 12)
//    }
//
//    var name: String? { nil }
//
//    var directory: String? { nil }
//
//    var isRecording: Bool { false }
//}


func `catch`(_ `do`: () throws -> Void) -> Error? {
    do {
        try `do`()
        return nil
    } catch {
        return error
    }
}

func `catch`<T>(_ `do`: () throws -> T) -> Result<T, Error> {
    do {
        return .success(try `do`())
    } catch {
        return .failure(error)
    }
}

extension ViewImageConfig {
    var previewDevice: PreviewDevice {
        PreviewDevice(stringLiteral: deviceName ?? "iPhone 13")
    }
}
