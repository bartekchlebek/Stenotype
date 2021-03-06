Pod::Spec.new do |spec|
  spec.name                  = 'Stenotype'
  spec.version               = '0.3.0'
  spec.summary               = 'Swift logging mechanism'
  spec.homepage              = 'https://github.com/bartekchlebek/Stenotype'
  spec.license               = { :type => 'MIT' }
  spec.author                = { 'Bartek Chlebek' => 'bartek.public@gmail.com' }
  spec.social_media_url      = 'http://twitter.com/bartekchlebek'
  spec.source                = { :git => 'https://github.com/bartekchlebek/Stenotype.git', :tag => "#{spec.version}" }
  spec.source_files          = 'Source/*.swift'
  spec.requires_arc          = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
end
