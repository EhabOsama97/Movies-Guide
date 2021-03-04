# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MovieApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MovieApp

  pod 'Firebase/Analytics'
  pod 'SDWebImage'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'ShimmerSwift'
  pod 'SideMenu'
  pod 'JGProgressHUD'
  pod 'IQKeyboardManagerSwift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end