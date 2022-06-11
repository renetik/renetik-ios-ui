#!/usr/bin/env sh

jazzy \
    --clean \
    --author Renetik \
    --author_url https://renetik.github.io \
    --source-host github \
    --source-host-url https://github.com/renetik/renetik-ios-ui \
    --module RenetikUI \
    --swift-build-tool xcodebuild --build-tool-arguments -scheme,RenetikUI-Package,-sdk,iphoneos
