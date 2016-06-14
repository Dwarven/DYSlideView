Pod::Spec.new do |s|

  s.name                  = 'DYSlideView'
  s.version               = '0.0.7'
  s.summary               = 'An iOS tabbed slide view.'
  s.homepage              = 'https://github.com/Dwarven/DYSlideView'
  s.ios.deployment_target = '7.0'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Dwarven' => 'prison.yang@gmail.com' }
  s.source                = { :git => 'https://github.com/Dwarven/DYSlideView.git', :tag => s.version }
  s.source_files          = 'Class/*.{h,m}'

end
