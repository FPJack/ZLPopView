// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "ZLPopView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "ZLPopView",
            targets: ["ZLPopView"]
        )
    ],
    targets: [
        .target(
            name: "ZLPopView",
            path: "ZLPopView/Classes",
            publicHeadersPath: ".",
            resources: [
                // 等价于 CocoaPods 的 resource_bundles
                .process("../Resources/PrivacyInfo.xcprivacy")
            ]
        )
    ]
)

