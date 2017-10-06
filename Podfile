# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target ‘RecipesList’ do
  use_frameworks!
  pod 'SwiftLint'
end

post_install do |installer|
   installer.pods_project.targets.each do |target|
     target.build_configurations.each do |configuration|
        configuration.build_settings['SWIFT_VERSION'] = '4.0'
     end
   end
 end

inhibit_all_warnings!
