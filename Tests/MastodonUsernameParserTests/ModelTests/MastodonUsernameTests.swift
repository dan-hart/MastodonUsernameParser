//
//  MastodonUsernameTests.swift
//  
//
//  Created by Dan Hart on 11/21/22.
//

import XCTest
@testable import MastodonUsernameParser

final class MastodonUsernameTests: XCTestCase {
    let codedbydan = MastodonUsername("codedbydan", domain: "mas.to")!
    let alice = MastodonUsername("alice", domain: "mastodon.social")!
    let erroredUsername = MastodonUsername("", domain: "")
    
    // MARK: - Init Tests
    func testHappyPathInit() {
        let username = MastodonUsername("codedbydan", domain: "mas.to")
        XCTAssertNotNil(username)
    }
    
    func testOneAt() {
        let username = MastodonUsername("@codedbydan", domain: "mas.to")
        XCTAssertNotNil(username)
    }
    
    func testMultipleAts() {
        let username = MastodonUsername("@@codedbydan@", domain: "mas.to")
        XCTAssertNotNil(username)
    }
    
    func testEmptyValues() {
        let username = MastodonUsername("", domain: "")
        XCTAssertNil(username)
    }
    
    func testInvalidDomains() { // ❌ Don't do this
        XCTAssertNil(MastodonUsername("alice", domain: "http://mas.to/"))
        XCTAssertNil(MastodonUsername("alice", domain: "http://mas.to"))
        XCTAssertNil(MastodonUsername("alice", domain: "https://mas.to"))
    }
    
    func testValidDomains() {
        XCTAssertNotNil(MastodonUsername("alice", domain: "mas.to"))
        XCTAssertNotNil(MastodonUsername("alice", domain: "://mas.to"))
        XCTAssertNotNil(MastodonUsername("alice", domain: "/mas.to/"))
    }
    
    // MARK: - Test properties
    
    func testFriendlyRepresentation() {
        XCTAssertEqual(codedbydan.friendlyRepresentation, "@codedbydan@mas.to")
        XCTAssertEqual(alice.friendlyRepresentation, "@alice@mastodon.social")
        XCTAssertEqual(MastodonUsername("", domain: "")?.friendlyRepresentation, nil)
    }
    
    func testURLString() {
        XCTAssertEqual(codedbydan.urlString, "https://mas.to/@codedbydan")
        XCTAssertEqual(alice.urlString, "https://mastodon.social/@alice")
        XCTAssertNil(erroredUsername?.urlString)
    }
    
    func testURL() {
        XCTAssertNotNil(codedbydan.url)
        XCTAssertNotNil(alice.url)
        XCTAssertNil(erroredUsername?.url)
    }
}
