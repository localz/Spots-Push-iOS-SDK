Pod::Spec.new do |s|
	s.name	= 'SpotzPushSDK'
	s.platform = :ios,'6.0'
	s.ios.deployment_target = '6.0'
	s.license = {
		:type => 'Commercial',
		:text => <<-LICENSE
			Copyright 2015 Localz Pty Ltd.
			LICENSE
	}
	s.version = '1.0.0'
	s.summary = 'iOS library for SpotzPush'
	s.homepage = 'http://localz.com'
	s.author = { 'Localz Pty Ltd' => 'info@localz.com' }
	s.source = { :git => "https://github.com/localz/Spotz-Push-SDK-iOS.git", :tag=>"1.0.0" }
	s.source_files = 'SpotzPushSDK/SpotzPushSDK.framework/Versions/A/Headers/*.h'
	s.requires_arc = true
	s.ios.deployment_target = '6.0'
	s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"${PODS_ROOT}/SpotzPushSDK"',
			'HEADER_SEARCH_PATHS' => '"${PODS_ROOT}/Headers/SpotzPushSDK"' }
#	s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(inherited)' }
#	s.preserve_paths = 'SpotzPushSDK.framework'
 	s.vendored_frameworks = 'SpotzPushSDK/SpotzPushSDK.framework'
	s.frameworks = 'UIKit','Foundation','CoreLocation'
end
