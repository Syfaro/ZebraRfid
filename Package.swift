// swift-tools-version: 6.2

import PackageDescription

let package = Package(
  name: "ZebraRfid",
  platforms: [
    .iOS(.v14)
  ],
  products: [
    .library(
      name: "ZebraRfid",
      targets: ["ZebraRfid"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/ZebraDevs/alt-rfid-ios-sdk", from: "0.1.14")
  ],
  targets: [
    .target(
      name: "ZebraRfid",
      dependencies: [
        .product(name: "Zebra123RFIDsdkSPM", package: "alt-rfid-ios-sdk")
      ]
    ),
    .testTarget(
      name: "ZebraRfidTests",
      dependencies: ["ZebraRfid"]
    ),
  ]
)
