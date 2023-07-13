import Foundation

extension Trafaret {
    static var fileManager: FileManager { .default }

    static func directoryURL(
        file: StaticString,
        named name: String?,
        in directory: String?
    ) -> URL {
        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let trafaretFileName = name ?? fileUrl.deletingPathExtension().lastPathComponent
        
        return directory.map { URL(fileURLWithPath: $0, isDirectory: true) }
        ?? fileUrl
            .deletingLastPathComponent()
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent(trafaretFileName)
    }
}

extension URL {
    func appendingPNGExtension() -> URL {
        appendingPathExtension("png")
    }
}
