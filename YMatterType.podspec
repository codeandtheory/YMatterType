Pod::Spec.new do |s|
  s.name                    = 'YMatterType'
  s.version                 = '1.6.0'
  s.summary                 = 'An opinionated take on Design System Typography for iOS and tvOS'
  s.homepage                = 'https://github.com/yml-org/YMatterType'
  s.license                 = { :type => 'Apache 2.0' }
  s.authors                 = { 'Y Media Labs' => 'support@ymedialabs.com' }
  s.source                  = { :git => 'https://github.com/yml-org/YMatterType.git', :tag => s.version }
  s.ios.deployment_target   = '14.0'
  s.tvos.deployment_target  = '14.0'
  s.swift_versions          = ['5']
  s.source_files            = 'Sources/YMatterType/**/*'
end
