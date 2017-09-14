Pod::Spec.new do |s|

  s.name                  = 'DYSlideView'
  s.version               = '0.0.16'
  s.summary               = 'An iOS tabbed slide view.'
  s.homepage              = 'https://github.com/tarokker/DYSlideView'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.social_media_url      = "https://twitter.com/DwarvenYang"
  s.source                = { :git => 'https://github.com/tarokker/DYSlideView.git', :tag => s.version }
  s.source_files          = 'Class/*.{h,m}'

end
