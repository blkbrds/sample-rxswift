source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

workspace 'RxSwift.xcworkspace'

target 'RxSwift' do
    project 'RxSwift'
    pod 'SAMKeychain', '~> 1.5.1'
    pod 'Alamofire', '~> 4.3.0'
    pod 'SwiftLint', '~> 0.16.1'
    pod 'RealmS', '~> 2.3.1'
    pod 'ObjectMapper', '2.2.6'
    pod 'RxSwift',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'RxCocoa',    '~> 3.0'
    pod 'MVVM-Swift'
    target 'RxSwiftTests' do
        project 'RxSwift'
        inherit! :search_paths
    end
end
