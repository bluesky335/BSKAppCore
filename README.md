#  iOS 开发基础脚手架 - iOS Develop Tool Code Collection

![GitHub](https://img.shields.io/github/license/bluesky335/BSKAppCore)

## 如何安装 - How to install
- CococaPods

    完整安装 - Full instal
    ``` ruby
        pod 'BSKAppCore', :branch => 'master'
    ```
    单个模块 - Single module install

    ``` ruby
        pod 'BSKAppCore/BSKLog', :branch => 'master'
        pod 'BSKAppCore/BSKLogConsole', :branch => 'master'
        pod 'BSKAppCore/BSKUtils', :branch => 'master'
    ```

-  Swift Package Manager

    完整安装 - Full instal
    ``` swift
        dependencies: [
            .package(url: "https://github.com/bluesky335/BSKAppCore.git", .branch("master"))
        ]
    ```
    单个模块 - Single module install

    ``` swift
        dependencies: [
            .package(url: "https://github.com/bluesky335/BSKAppCore.git", .branch("master"))
        ]
    ```