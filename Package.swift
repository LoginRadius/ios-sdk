// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoginRadiusPackage",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LoginRadiusPackage",
            targets: ["LoginRadiusPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git",
                 .upToNextMajor(from: "14.1.0"))

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LoginRadiusPackage",
            dependencies: [.product(name: "FacebookCore", package: "facebook-ios-sdk"),
                           .product(name: "FacebookLogin", package: "facebook-ios-sdk")],
            path: "Sources",
        
            linkerSettings: [
            .linkedFramework("SafariServices"),
            .linkedFramework("UIKit"),
            .linkedFramework("Foundation"),
            .linkedFramework("SystemConfiguration"),
            .linkedFramework("Social"),
            .linkedFramework("Accounts")
        ]
            ),
        
    ]
)
