// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumiPluginToast",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "PluginToast", targets: ["PluginToast"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CofficLab/LumiKernel.git", from: "1.0.0"),
        .package(url: "https://github.com/CofficLab/LumiLogging.git", from: "1.0.1"),
        .package(url: "https://github.com/CofficLab/LumiLocalization.git", from: "1.0.0"),
        .package(url: "https://github.com/CofficLab/LumiProviders.git", from: "1.3.4"),
        .package(url: "https://github.com/CofficLab/LumiUI.git", from: "1.7.0"),
    ],
    targets: [
        .target(
            name: "PluginToast",
            dependencies: [
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "LumiLoggingKit", package: "LumiLogging"),
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
                .product(name: "ProviderToast", package: "LumiProviders"),
                .product(name: "LumiUI", package: "LumiUI"),
            ],
            resources: [.process("../../Resources/Localizable.xcstrings")]
        ),
        .testTarget(
            name: "PluginToastTests",
            dependencies: [
                "PluginToast",
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderToast", package: "LumiProviders"),
            ]
        ),
    ]
)
