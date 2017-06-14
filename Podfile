source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

workspace 'RxSwift-Demo.xcworkspace'

target 'RxSwift-Demo' do
    project 'RxSwift-Demo'
    pod 'SAMKeychain', '~> 1.5.1'
    pod 'Alamofire', '~> 4.3.0'
    pod 'Kingfisher', '~> 3.5.2'
    pod 'SwiftLint', '~> 0.16.1'
    pod 'RealmS', '~> 2.3.1'
    pod 'ObjectMapper', '2.2.6'
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'MVVM-Swift'
    target 'RxSwift-DemoTests' do
        project 'RxSwift-Demo'
        inherit! :search_paths
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'RxSwift'
            target.build_configurations.each do |config|
                if config.name == 'Debug'
                    config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                end
            end
        end
    end
end
