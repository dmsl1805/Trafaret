import Foundation
import XCTest
@testable import Trafaret

final class FilePathTest: XCTestCase {
    func testFormattedName() {
        var filePath = FilePath.defaultFile()
        
        let check = {
            XCTAssertEqual(
                filePath.formattedName,
                String(describing: FilePathTest.self)
            )
        }

        check()
        
        filePath = FilePath.custom(
            module: "",
            directory: "",
            name: String(describing: FilePathTest.self)
        )

        check()
    }
    
    func testDefaultTrafaretFileURL() {
        let filePath = FilePath.defaultFile()
        
        let expectedPath = "TrafaretTests/__Trafarets__/\(String(describing: FilePathTest.self)).png"
        
        XCTAssertTrue(
            filePath.trafaretFileURL.absoluteString.hasSuffix(expectedPath),
            "\(filePath.trafaretFileURL.absoluteString) is not equal to: \(expectedPath)"
        )
    }
    
    func testDefaultTestFileURL() {
        let filePath = FilePath.defaultFile(
            filePath: Trafaret.filePath(),
            fileID: Trafaret.fileID()
        )
        
        let expectedPath = "Tests/TrafaretTests/FilePathSnapshotTest.swift"
        
        XCTAssertTrue(
            filePath.testFileURL.absoluteString.hasSuffix(expectedPath),
            "\(filePath.testFileURL.absoluteString) is not equal to: \(expectedPath)"
        )
    }
}
