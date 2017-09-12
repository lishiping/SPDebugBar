
Pod::Spec.new do |s|

  s.name         = "SPDebugBar"
  s.version      = "0.4.0"
  s.summary      = "Help switch server address in the debug,test package,And show CPU,Memory,FPS.设置环境,在debug或测试包上切换服务器地址,显示CPU,Memory,FPS"


  s.homepage     = "https://github.com/lishiping/SPDebugBar.git"
  s.license      = "LICENSE"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "lishiping" => "83118274@qq.com" }

  s.ios.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/lishiping/SPDebugBar.git", :tag => s.version }

   s.source_files  = 'SPDebugBar/SPDebugBar/*.{h,m,mm,cpp,c}', 'SPDebugBar/SPDebugBar/*/*.{h,m,mm,cpp,c}'
   s.public_header_files = 'SPDebugBar/SPDebugBar/*.h', 'SPDebugBar/SPDebugBar/*/*.h'

  s.framework  = "UIKit"
  s.requires_arc = true

 # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }

end
