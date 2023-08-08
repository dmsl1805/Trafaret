import Foundation
import UIKit

public enum FilePath {
    case defaultFile(filePath: StaticString = #filePath, fileID: String = #fileID)
    
    case custom(
        module: String,
        directory: String,
        name: String,
        fileExtension: String? = nil
    )
    
    public static func custom(
        module: String? = nil,
        directory: String? = nil,
        name: String? = nil,
        fileExtension: String? = nil,
        filePath: StaticString = #filePath,
        fileID: String = #fileID
    ) -> Self {
        lazy var defaultFile = Self.defaultFile(filePath: filePath, fileID: fileID)
        lazy var defaultModule = defaultFile.moduleName
        lazy var defaultDirectory = defaultFile.trafaretFileURL.deletingLastPathComponent().absoluteString
        lazy var defaultName = defaultFile.formattedName

        return .custom(
            module: module ?? defaultModule,
            directory: directory ?? defaultDirectory,
            name: name ?? defaultName,
            fileExtension: fileExtension
        )
    }
        
    public var formattedName: String {
        "\(formattedViewName)Preview"
    }
    
    public var formattedViewName: String {
        switch self {
        case let .defaultFile(filePath, _):
            let fileURL = URL(fileURLWithPath: "\(filePath)", isDirectory: false)
            return fileURL.deletingPathExtension().lastPathComponent
            
        case let .custom(_, _, name, _):
            return name
        }
    }
    
    public var moduleName: String {
        switch self {
        case let .defaultFile(_, fileID):
            return fileID.components(separatedBy: "/").first ?? ""
            
        case let .custom(module, _, _, _):
            return module
        }
    }
    
    public func trafaretImage(scale: CGFloat) throws -> UIImage? {
        UIImage(data: try Data(contentsOf: trafaretFileURL), scale: scale)
    }
    
    var fileManager: FileManager { .default }

    public var trafaretFileURL: URL {
        let defaultFileExtension = "png"
        
        switch self {
        case let .defaultFile(filePath, _):
            let fileURL = URL(fileURLWithPath: "\(filePath)", isDirectory: false)
            let fileName = fileURL.deletingPathExtension().lastPathComponent
            
            return fileURL
                .deletingLastPathComponent()
                .appendingPathComponent("__Trafarets__")
                .appendingPathComponent(fileName)
                .appendingPathExtension(defaultFileExtension)

        case let .custom(_, directory, name, fileExtension):
            return URL(fileURLWithPath: directory, isDirectory: true)
                .appendingPathComponent(name)
                .appendingPathExtension(fileExtension ?? defaultFileExtension)
        }
    }
    
    public var testFileURL: URL {
        let defaultFileExtension = "swift"

        switch self {
        case .defaultFile(let filePath, var fileID):
            let originalFileID = fileID
            var components = originalFileID.components(separatedBy: "/")
            components[0] = "\(components[0])Tests"
            components.insert("Tests", at: 0)
            fileID = components.joined(separator: "/")
            let filePath = "\(filePath)"
                .replacingOccurrences(of: "Sources/\(originalFileID)", with: fileID)
            
            let fileURL = URL(fileURLWithPath: filePath, isDirectory: false)
            let fileName = "\(fileURL.deletingPathExtension().lastPathComponent)SnapshotTest"

            return fileURL
                .deletingLastPathComponent()
                .appendingPathComponent(fileName)
                .appendingPathExtension(defaultFileExtension)

        case let .custom(_, directory, name, _):
            return URL(fileURLWithPath: directory, isDirectory: true)
                .appendingPathComponent(name)
                .appendingPathExtension(defaultFileExtension)
        }
    }
}

#if DEBUG
// For testing purposes only

func fileID() -> String {
    #fileID
}

func filePath() -> StaticString {
    #filePath
}
#endif
