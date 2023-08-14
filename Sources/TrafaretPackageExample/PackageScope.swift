import Foundation
import Trafaret

private let moduleFilePath: StaticString = #filePath
private let moduleFileID: String = #fileID

private func fileName(
    filePath: StaticString
) -> String {
    let fileURL = URL(fileURLWithPath: "\(filePath)", isDirectory: false)
    return "\(fileURL.deletingPathExtension().lastPathComponent)"
}

private var trafaretDirectory: String {
    var components = "\(moduleFilePath)".components(separatedBy: "/")
    components.removeLast()
    components.append("__Trafarets__")
    return components.joined(separator: "/")
}

private var testDirectory: String {
    let moduleName = moduleFileID.components(separatedBy: "/").first ?? ""
    
    var components = "\(moduleFilePath)".components(separatedBy: "/")
    components.removeLast(3)
    components.append("Tests/\(moduleName)Tests")
    return components.joined(separator: "/")
}

enum Package {
    static func trafaretFilePath(
        filePath: StaticString = #filePath,
        fileID: String = #fileID
    ) -> FilePath {
        .custom(
            directory: trafaretDirectory,
            name: fileName(filePath: filePath),
            filePath: filePath,
            fileID: fileID
        )
    }
    
    static func testConfig(
        filePath: StaticString = #filePath,
        fileID: String = #fileID
    ) -> TestConfig {
        TestConfig(
            directory: testDirectory,
            name: fileName(filePath: filePath),
            filePath: filePath,
            fileID: fileID
        )
    }
}


