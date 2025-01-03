//
//  Tags.TestDependencies.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Tags
import IssueReporting
import TestShared
import Shared
import Authenticated

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

typealias AuthenticatedClient = Authenticated.Client<Tags.API, Tags.API.Router, Tags.Client>

extension AuthenticatedClient: TestDependencyKey {
    public static var testValue: Self {
        try! Authenticated.Client.test {
            Client.testValue
        }
    }
    
    public static var liveTest: Self {
        try! Authenticated.Client.test { apiKey, baseUrl, domain, makeRequest in
            Client.live(
                apiKey: apiKey,
                baseUrl: baseUrl,
                domain: domain,
                makeRequest: makeRequest
            )
        }
    }
}

extension Tags.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}