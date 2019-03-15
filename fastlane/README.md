fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios setup
```
fastlane ios setup
```
cocoapods 安装
### ios screenshots
```
fastlane ios screenshots
```
截图
### ios build
```
fastlane ios build
```
创建 Release ipa
### ios release
```
fastlane ios release
```
部署 AppStore
### ios increment_build
```
fastlane ios increment_build
```
增加 build num
### ios deploy_apple_store
```
fastlane ios deploy_apple_store
```
部署 AppStore
### ios certificates
```
fastlane ios certificates
```
证书

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
