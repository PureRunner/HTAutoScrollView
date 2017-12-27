Pod::Spec.new do |s|
  s.name         = "HTAutoScrollView"
  s.version      = "1.0.0"
  s.summary      = "HTAutoScrollView ."
  s.homepage     = "https://github.com/PureRunner/HTAutoScrollView"
  s.license      = "MIT"
  s.author             = { "PureRunner" => "teemofaster@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/PureRunner/HTAutoScrollView.git", :tag => "1.0.0" }
  s.source_files  = "HTAutoScrollView/AutoScrollView/*"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
end
