// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let mailgun: Self = "Mailgun"
}

extension Target.Dependency {
    static var mailgun: Self { .target(name: .mailgun) }
}

extension Target.Dependency {
    static var coenttbWeb: Self { .product(name: "CoenttbWeb", package: "coenttb-web") }
    static var basicAuth: Self { .product(name: "BasicAuth", package: "swift-authentication") }
    static var dependenciesTestHelpers: Self { .product(name: "DependenciesTestSupport", package: "swift-dependencies") }
    static var environmentVariables: Self { .product(name: "EnvironmentVariables", package: "swift-environment-variables") }
    static var issueReporting: Self { .product(name: "IssueReporting", package: "xctest-dynamic-overlay") }
}

let package = Package(
    name: "coenttb-mailgun",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .mailgun, targets: [.mailgun]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/coenttb-web", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-environment-variables", branch: "main"),
        .package(url: "https://github.com/coenttb/swift-authentication", branch: "main"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.5"),
        .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.4.3"),
    ],
    targets: [
        .target(
            name: .mailgun,
            dependencies: [
                .basicAuth,
                .coenttbWeb,
                .issueReporting
            ]
        ),
        .testTarget(
            name: .mailgun + " Tests",
            dependencies: [
                .mailgun,
                .environmentVariables,
                .dependenciesTestHelpers
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
