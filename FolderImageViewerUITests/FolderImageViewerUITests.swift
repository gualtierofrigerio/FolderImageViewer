//
//  FolderImageViewerUITests.swift
//  FolderImageViewerUITests
//
//  Created by Gualtiero Frigerio on 19/01/2019.
//

import XCTest

class FolderImageViewerUITests: XCTestCase {
    
    var app:XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFirstFolder() {
        startBrowsing()
        let table = app.tables["Root folder"]
        XCTAssert(table.cells.count == 3)
    }
    
    func testFolderA() {
        startBrowsing()
        
        let cellA = getFolderACell()
        let cellAText = cellA.staticTexts.element(boundBy: 0).label
        
        XCTAssertEqual(cellAText, "folderA")
    }
    
    func testFolderAContent() {
        startBrowsing()
        
        let cellA = getFolderACell()
        cellA.tap()
        
        XCTAssertTrue(isShowingFolderA())
        
        let firstImageCell = getFirstImageFolderA()
        firstImageCell.tap()
        
        XCTAssertTrue(isShowingImages())
        
        let subviews = getScrollViewContent()
        XCTAssertEqual(subviews.count, 2)
    }

}

extension FolderImageViewerUITests {
    
    func getFolderACell() -> XCUIElement {
        let table = app.tables["Root folder"]
        let cellA = table.cells.element(boundBy: 0)
        return cellA
    }
    
    func getFirstImageFolderA() -> XCUIElement {
        let table = app.tables["folderA"]
        let firstCell = table.cells.element(boundBy:0)
        return firstCell
    }
    
    func getScrollViewContent() -> [XCUIElement] {
        let imageScrollVC = app.otherElements["imageScrollViewController"]
        let scrollView = imageScrollVC.children(matching: .scrollView)
        let internalView = scrollView.otherElements["scrollViewContainer"]
        XCTAssertTrue(internalView.exists)
        let images = internalView.children(matching: .any)
        return images.allElementsBoundByAccessibilityElement
    }
    
    func isShowingFolderA() -> Bool {
        return app.otherElements["folderA"].exists
    }
    
    func isShowingFoldersModal() -> Bool {
        return app.tables["Root folder"].exists
    }
    
    func isShowingImages() -> Bool {
        return app.otherElements["imageScrollViewController"].exists
    }
    
    func startBrowsing() {
        app.launch()
        let button = app.buttons["Start browsing"]
        button.tap()
        
        XCTAssertTrue(isShowingFoldersModal())
    }
}
