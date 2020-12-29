
Pod::Spec.new do |s|

  s.name         = "SPDebugBar"
  s.version      = "1.1.3"
  s.summary      = "Switch address,Modify NSUserDefaults,Show CPU,Memory,FPS.切换服务器地址,修改NSUserDefaults,显示CPU,内存,FPS"

  s.homepage     = "https://github.com/lishiping/SPDebugBar.git"
  s.license      = "LICENSE"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "lishiping" => "83118274@qq.com" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/lishiping/SPDebugBar.git", :tag => s.version }

   s.source_files  = 'SPDebugBar/SPDebugBar/*.{h,m,mm,cpp,c}', 'SPDebugBar/SPDebugBar/*/*.{h,m,mm,cpp,c}'
   s.public_header_files = 'SPDebugBar/SPDebugBar/*.h', 'SPDebugBar/SPDebugBar/*/*.h'

  s.framework  = "UIKit"
  s.requires_arc = true

 # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }

end
