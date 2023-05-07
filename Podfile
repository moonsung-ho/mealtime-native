# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'mealtime (iOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'SwiftyJSON', '~> 4.0'
pod 'Google-Mobile-Ads-SDK'
pod 'AlertToast'
  # Pods for mealtime (iOS)

end

target 'mealtime (macOS)' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'SwiftyJSON', '~> 4.0'
  # Pods for mealtime (macOS)

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
  installer.pods_project.targets.each do |target|
  end
end
