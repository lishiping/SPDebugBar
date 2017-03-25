
Pod::Spec.new do |s|

  s.name         = "SPDebugBar"
  s.version      = "0.0.7"
  s.summary      = "A tool to help developers and testers quickly switch the server address, convenient to debug the program.一个小工具帮助开发人员和测试人员快速切换服务器地址，方便调试程序"


  s.homepage     = "https://github.com/lishiping/SPDebugBar.git"
  s.license      = "LICENSE"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "lishiping" => "83118274@qq.com" }

  s.ios.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/lishiping/SPDebugBar.git", :tag => "0.0.7" }

   s.source_files  = 'SPDebugBar/SPDebugBar/*.{h,m,mm,cpp,c}', 'SPDebugBar/SPDebugBar/*/*.{h,m,mm,cpp,c}'
   s.public_header_files = 'SPDebugBar/SPDebugBar/*.h', 'SPDebugBar/SPDebugBar/*/*.h'

  s.framework  = "UIKit"
  s.requires_arc = true

 # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }

end
