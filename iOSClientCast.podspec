Pod::Spec.new do |spec|
spec.name         = "iOSClientCast"
spec.version      = "4.1.0"
spec.summary      = "RedBeeMedia iOS SDK Google Cast Module"
spec.homepage     = "https://github.com/EricssonBroadcastServices"
spec.license      = { :type => "Apache", :file => "LICENSE" }
spec.author             = { "EMP" => "jenkinsredbee@gmail.com" }
spec.documentation_url = "https://github.com/EricssonBroadcastServices/iOSClientCast/blob/master/README.md"
spec.platforms = { :ios => "12.0" }
spec.source       = { :git => "https://github.com/EricssonBroadcastServices/iOSClientCast.git", :tag => "v#{spec.version}" }
spec.source_files  = "Sources/iOSClientCast/**/*.swift"
spec.static_framework = true
spec.ios.vendored_frameworks = 'Sources/GoogleCast/GoogleCast.xcframework'
spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
spec.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
spec.resource_bundles = { "iOSClientCast.git" => ["Sources/iOSClientCast/PrivacyInfo.xcprivacy"] }
end
