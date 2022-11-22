//
//  MastodonUsername.swift
//  
//
//  Created by Dan Hart on 11/21/22.
//

import Foundation

enum URLScheme: String {
    case http = "http://"
    case https = "https://"
}

/// https://docs.joinmastodon.org/user/signup/
class MastodonUsername: Equatable {
    // MARK: - Constants
    let at = "@"
    
    static func == (lhs: MastodonUsername, rhs: MastodonUsername) -> Bool {
        lhs.localUsername == rhs.localUsername
        && lhs.domain == rhs.domain
    }
    
    // MARK: - Properties
    
    /// Username without an @ symbol
    private var localUsername: String
    
    /// the non-fully qualified domain:
    /// examples:
    /// - mastodon.social
    /// - mas.to
    private var domain: String
    
    /// http:// or https:// -- default to secure
    var scheme: URLScheme
    
    // MARK: - Init
    init?(_ username: String, domain: String, scheme: URLScheme = .https) {
        self.localUsername = username
        self.domain = domain
        self.scheme = scheme
        
        if localUsername.isEmpty
            || domain.isEmpty {
            return nil
        }
        
        localUsername.removeAll { c in
            "\(c)" == at
        }
        
        if localUsername.localizedCaseInsensitiveContains(at) {
            return nil
        }
        
        self.domain.removeAll { c in
            "\(c)" == ":"
        }
        
        self.domain.removeAll { c in
            "\(c)" == "/"
        }
        
        if self.domain.localizedCaseInsensitiveContains(":")
            || self.domain.localizedCaseInsensitiveContains("/")
            || self.domain.localizedCaseInsensitiveContains("http") {
            return nil
        }
    }
    
    // MARK: - Computed Properties
    /// example: `@alice@mastodon.social`
    var friendlyRepresentation: String {
        "\(at)\(localUsername)\(at)\(domain)"
    }
    
    var urlString: String {
        "\(scheme.rawValue)\(domain)/\(at)\(localUsername)"
    }
    
    var url: URL? {
        URL(string: urlString)
    }
}
