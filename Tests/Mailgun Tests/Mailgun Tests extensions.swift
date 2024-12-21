//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Foundation
import EnvironmentVariables
import Mailgun
import Testing

extension URL {
    static var projectRoot: URL {
        return .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension EnvironmentVariables {
    // Mailgun
    var mailgunBaseUrl: URL? {
        get { self["MAILGUN_BASE_URL"].flatMap(URL.init(string:)) }
        set { self["MAILGUN_BASE_URL"] = newValue?.absoluteString }
    }
    
    var mailgunPrivateApiKey: String? {
        get { self["MAILGUN_PRIVATE_API_KEY"] }
        set { self["MAILGUN_PRIVATE_API_KEY"] = newValue }
    }
    
    var mailgunDomain: String? {
        get { self["MAILGUN_DOMAIN"] }
        set { self["MAILGUN_DOMAIN"] = newValue }
    }
    
    var mailgunFrom: String? {
        get { self["MAILGUN_FROM_EMAIL"] }
        set { self["MAILGUN_FROM_EMAIL"] = newValue }
    }
    
    var mailgunTo: String? {
        get { self["MAILGUN_TO_EMAIL"] }
        set { self["MAILGUN_TO_EMAIL"] = newValue }
    }
}

extension EnvVars {
    public static let local: Self = try! .live(localDevelopment: .projectRoot.appendingPathComponent(".env.development"))
}

extension Mailgun.Client {
    static var liveTest: Mailgun.Client {
        try! withDependencies {
            $0.envVars = .local
        } operation: {
            @Dependency(\.envVars) var envVars
            
            let apiKey: Client.ApiKey = try #require(envVars.mailgunPrivateApiKey.map(Client.ApiKey.init(rawValue:)))
            let baseUrl = try #require(envVars.mailgunBaseUrl)
            let domain = try #require(envVars.mailgunDomain)
            
            
            return Mailgun.Client.live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                session: { request in
                    try await URLSession.shared.data(for: request)
                }
            )
        }
    }
}
