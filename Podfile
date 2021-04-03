platform :ios, '13.0'

target 'VirtualCourses' do
  use_frameworks!

  # Pods for VirtualCourses
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  
  pod 'Firebase/Firestore'
  
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
   end
  end
end
