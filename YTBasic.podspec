
Pod::Spec.new do |s|
  s.name             = 'YTBasic'
  s.version          = '0.1.2'
  s.summary          = '基础工具类库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/CCCCCode'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'durant' => 'CCCCode' }
  s.source           = { :git => 'https://github.com/CCCCCode/YTBasic.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'

  s.source_files = 'YTBasic/Classes/YTBasic.h'

  s.subspec 'Global' do |ss|
    ss.source_files = 'YTBasic/Classes/Global/**/*'
  end

  s.subspec 'Fundation' do |ss|
    ss.source_files = 'YTBasic/Classes/Fundation/**/*'
  end

  s.subspec 'UIKit' do |ss|
    ss.source_files = 'YTBasic/Classes/UIKit/**/*'
    ss.dependency 'YTBasic/Global'
    ss.frameworks = 'ImageIO', 'Accelerate'
  end

  s.subspec 'Toast' do |ss|
    ss.source_files = 'YTBasic/Classes/Toast/**/*'
    ss.dependency 'YTBasic/UIKit'
  end

end
