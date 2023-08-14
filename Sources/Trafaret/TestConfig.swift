import Foundation

public struct TestConfig {
    public let path: FilePath
    public let perceptualPrecision: Float
    
    public init(path: FilePath, perceptualPrecision: Float) {
        self.path = path
        self.perceptualPrecision = perceptualPrecision
    }
    
    public init(
        filePath: StaticString = #filePath,
        fileID: String = #fileID,
        perceptualPrecision: Float = 0.9
    ) {
        self.path = .defaultFile(filePath: filePath, fileID: fileID)
        self.perceptualPrecision = perceptualPrecision
    }
    
    public init(
        module: String? = nil,
        directory: String? = nil,
        name: String,
        fileExtension: String? = nil,
        perceptualPrecision: Float = 0.9,
        filePath: StaticString = #filePath,
        fileID: String = #fileID
    ) {
        self.path = .custom(
            module: module,
            directory: directory,
            name: name,
            fileExtension: fileExtension,
            filePath: filePath,
            fileID: fileID
        )
        self.perceptualPrecision = perceptualPrecision
    }
}
