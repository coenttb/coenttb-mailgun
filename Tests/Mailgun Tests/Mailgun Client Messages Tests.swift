import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Mailgun
import IssueReporting

@Suite(
    .dependency(\.envVars, .local),
    .dependency(\.mailgunClient, .liveTest ),
    .disabled("Waiting till Mailgun account suspension is resolved.")
)
struct MailgunLiveTests {
    @Test("Should successfully send an email")
    func testSendEmail() async throws {
        @Dependency(\.mailgunClient) var mailgunClient
        @Dependency(\.envVars) var envVars
        
        let from = try #require(envVars.mailgunFrom)
        let to = try #require(envVars.mailgunTo)

        let request = Mailgun.Messages.Send.Request(
            // Use the exact domain format
            from: from,
            to: [to],
            subject: "Test Email from Mailgun Swift SDK",
            html: "<h1>Hello from Tests!</h1><p>This is a test email sent via Mailgun.</p>",
            text: "Hello from Tests! This is a test email sent via Mailgun.",
            testMode: true
        )
        
        let response = try await mailgunClient.messages.send(request: request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}

extension URLRequest {
    var allHTTPHeaders: [String: String]? {
        allHTTPHeaderFields?.mapValues { $0 }
    }
}
