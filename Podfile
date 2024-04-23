# Uncomment the next line to define a global platform for your project
 platform :ios, '16.0'

def third_party_libraries_testing_source
  pod 'FirebaseFirestoreSwift'
  pod 'FirebaseFirestore'
  pod 'OnewsSDK', :git => 'https://github.com/sizwek06/onews-sdk.git'
end

target 'Onews' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  third_party_libraries_testing_source
  
  target 'OnewsTests' do
    inherit! :search_paths
    third_party_libraries_testing_source
  end

  # Pods for Onews
pod 'Kingfisher', '~> 7.0'
pod 'SwiftLint'
pod 'FirebaseAuth'

end
