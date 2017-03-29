
Pod::Spec.new do |s|

  s.name         = "SPDebugBar"
  s.version      = "0.0.8"
  s.summary      = "Set up the environment,help developers and testers switch server address in the debug mode or the test package,debug the program.设置环境，帮助开发者和测试者在debug模式下或者测试包上切换服务器地址，调试程序"


  s.homepage     = "https://github.com/lishiping/SPDebugBar.git"
  s.license      = "LICENSE"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "lishiping" => "83118274@qq.com" }

  s.ios.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/lishiping/SPDebugBar.git", :tag => "0.0.8" }

   s.source_files  = 'SPDebugBar/SPDebugBar/*.{h,m,mm,cpp,c}', 'SPDebugBar/SPDebugBar/*/*.{h,m,mm,cpp,c}'
   s.public_header_files = 'SPDebugBar/SPDebugBar/*.h', 'SPDebugBar/SPDebugBar/*/*.h'

  s.framework  = "UIKit"
  s.requires_arc = true

 # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }

end
