#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'sms_autofill'
  s.version          = '0.0.1'
  s.summary          = 'Flutter plugin to provide SMS code autofill support'
  s.description      = <<-DESC
  SMS Autofill ozelligini desteklemek icin olusturulmus bir pakettir
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = 'MIT'
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :git => 'https://github.com/PingpongUniversity/sms_autofill.git',:tag => '1.0.2' }
  s.source_files = 'ios/Classes/**'
  s.public_header_files = 'ios/Classes/**.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '11.0'
end

