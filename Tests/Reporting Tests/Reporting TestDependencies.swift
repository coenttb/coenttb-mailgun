//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import TestShared
import Shared
import Authenticated
import Reporting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Authenticated.Client<Reporting.API, Reporting.API.Router, Reporting.Client>

extension AuthenticatedClient: TestDependencyKey {
    public static var testValue: Self {
        try! Authenticated.Client.test {
            Reporting.Client.testValue
        }
    }
    
    public static var liveTest: Self {
        try! Authenticated.Client.test { apiKey, baseUrl, domain, makeRequest in
            .live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                makeRequest: makeRequest
            )
        }
    }
}

extension Reporting.API.Router: TestDependencyKey {
    public static let testValue: Reporting.API.Router = .init()
}

extension DependencyValues {
    var suppressions: AuthenticatedClient {
        get { self[AuthenticatedClient.self] }
        set { self[AuthenticatedClient.self] = newValue }
    }
}
