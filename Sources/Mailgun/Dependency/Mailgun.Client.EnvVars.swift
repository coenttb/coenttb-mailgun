//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Foundation
import MemberwiseInit

extension Mailgun.Client {
    @MemberwiseInit(.public)
    public struct EnvVars: Codable {
        public var baseUrl: String
        public var apiKey: Mailgun.Client.ApiKey
        public var domain: Mailgun.Client.Domain
    }
}
