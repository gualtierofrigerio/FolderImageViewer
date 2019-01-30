//
//  FolderImageViewerTests.swift
//  FolderImageViewerTests
//
//  Created by Gualtiero Frigerio on 19/01/2019.
//

import XCTest
@testable import FolderImageViewer

class FolderImageViewerTests: XCTestCase {

    var basePath:String!
    let dataSource = DataSource()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        basePath = Bundle.main.bundlePath + "/test"
        dataSource.setBasePath(path: basePath)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDataSourceGetSubfolders() {
        let subfolders = dataSource.getSubFolders(ofFolder: "")
        XCTAssertEqual(subfolders, ["folderA", "folderB"])
    }
    
    func testDataSourceGetFolder() {
        let files = dataSource.getFiles(inSubfolder: "folderA")
        XCTAssertNotNil(files)
        if let files = files {
            let filesPaths = files.map{(entry) -> String in
                return entry.path
            }
            XCTAssertEqual(filesPaths, ["fa1.jpg", "fa2.jpg", "fa3.jpg"])
        }
    }

}
