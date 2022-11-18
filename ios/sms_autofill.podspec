Pod::Spec.new do |spec|
  spec.name         = "sms_autofill"
  spec.version      = "0.0.1"
  spec.summary      = "Bu repo sms autofill özelliğinin ayrıştırılması için oluşturulmuştur"
  spec.description  = <<-DESC
  Controller that extends TextEditingController and can recieve OTP verification code
                   DESC
  spec.homepage     = "https://github.com/PingpongUniversity/sms_autofill"
  spec.license      = { :type => 'MIT', :file => "../LICENSE" }
  spec.author             = { "Pingpong Mobile" => "ahmet.oktay@pingpong.university" }
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/PingpongUniversity/sms_autofill.git"}
  spec.source_files = 'ios/Classes/*'
  spec.public_header_files = "ios/Classes/*.h"
  spec.swift_versions = ["5.0", "5.1", "5.2", "5.3"]
  spec.dependency 'Flutter'
end
