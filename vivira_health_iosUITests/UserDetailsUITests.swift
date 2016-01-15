import XCTest

class UserDetailsUITests: XCTestCase {
    
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchEnvironment["TEST"] = "1"
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldShowUserName() {
        // Given I have a user Ronald Sanders
        
        // When I select this user from the list
        app.tables.staticTexts["Ronald Sanders"].tap()
        
        // Then I should see
        XCTAssert(app.staticTexts["ronald.sanders@gmail.com"].exists)
        XCTAssert(app.staticTexts["Ronald Sanders"].exists)
    }
    
}