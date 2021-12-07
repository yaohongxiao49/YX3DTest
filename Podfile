platform :ios, '10.0'
inhibit_all_warnings!

target '3DTest' do

#source 'https://github.com/CocoaPods/Specs.git'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

pod 'ZFPlayer'
pod 'ZFPlayer/ControlView'
pod 'ZFPlayer/AVPlayer'

post_install do |installer|
  installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
  if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 10.0
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
     end
   end
  end
end
end
