platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

target 'RKProject' do

pod 'SnapKitExtend','1.0.7'
pod 'Then','2.5.0'
pod 'Moya','14.0.0'
pod 'HandyJSON','5.0.0'
#图片
pod 'Kingfisher','4.10.1'
#tab、collection
pod 'Reusable','4.1.0'
#轮播
pod 'LLCycleScrollView','1.5.4'
pod 'MJRefresh','3.5.0'
pod 'MBProgressHUD','1.2.0'
pod 'HMSegmentedControl','1.5.5'
pod 'IQKeyboardManagerSwift','6.4.1'
pod 'EmptyDataSet-Swift','4.2.0'
pod 'UINavigation-SXFixSpace','1.2.4'

pod 'RxSwift', '6.0.0'
pod 'RxCocoa', '6.0.0'




post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end

end
