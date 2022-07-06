#
#  Be sure to run `pod spec lint YMatterType.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#

Pod::Spec.new do |spec|
  spec.name             = "YMatterType"
  spec.version          = "1.0.2"
  spec.summary          = "An opinionated take on Design System Typography for iOS."
  spec.description      = "This framework uses Figma's concept of Typography to create text-based UI elements (labels, buttons, text fields, and text views) that render themselves as described in Figma design files (especially sizing themselves according to line height) while also supporting Dynamic Type scaling and the Bold Text accessibility setting."
  spec.homepage         = "https://github.com/yml-org/YMatterType"
  spec.license          = "Apache License, Version 2.0"
  spec.author           = "Mark Pospesel, Sanjib Chakraborty, Sumit Goswami, Karthik K Manoj, Visakh Tharakan, et al"
  spec.social_media_url = "https://twitter.com/Yml_co"
  spec.platform         = :ios, "14.0"
  spec.swift_version    = '5.5'
  spec.source           = { :git => "https://github.com/yml-org/YMatterType.git", :tag => spec.version }
  spec.source_files     = "Sources/**/*"
end
