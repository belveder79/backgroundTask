#!/bin/bash
xcodebuild -sdk iphonesimulator14.5 -project "BackgroundTask.xcodeproj" -target "SwiftAudioProxy" -configuration Release
xcodebuild -sdk iphoneos14.5 -project "BackgroundTask.xcodeproj" -target "SwiftAudioProxy" -configuration Release
cd build
cp -R "Release-iphoneos" "Release-fat"
cp -R "Release-iphonesimulator/SwiftAudioProxy.framework/Modules/SwiftAudioProxy.swiftmodule/" "Release-fat/SwiftAudioProxy.framework/Modules/SwiftAudioProxy.swiftmodule/"
lipo -extract x86_64 Release-iphonesimulator/SwiftAudioProxy.framework/SwiftAudioProxy -output Release-iphonesimulator/SwiftAudioProxy.framework/SwiftAudioProxy_x86_64
lipo -create -output "Release-fat/SwiftAudioProxy.framework/SwiftAudioProxy" "Release-iphoneos/SwiftAudioProxy.framework/SwiftAudioProxy" "Release-iphonesimulator/SwiftAudioProxy.framework/SwiftAudioProxy_x86_64"
sharpie bind --sdk=iphoneos14.5 --output "XamarinApiDef" --namespace="Binding" --scope="Release-fat/SwiftAudioProxy.framework/Headers/" "Release-fat/SwiftAudioProxy.framework/Headers/SwiftAudioProxy-Swift.h"
cd ..
