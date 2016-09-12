Pod::Spec.new do |spec|
  spec.name         = 'CKMessagesKit'
  spec.version      = '1.0.8'
  spec.license      = 'MIT'
  spec.homepage     = 'https://github.com/xmkevinchen/CKMessagesKit'
  spec.authors      = { 'Kevin Chen' => 'xmkevinchen@gmail.com' }
  spec.summary      = 'A Swiftified, open source, Protocol-Orietated Messages UI Kit for iOS'
  spec.source       = {
                        :git => 'https://github.com/xmkevinchen/CKMessagesKit.git',
                        :tag => spec.version.to_s
                      }

  spec.platform       = :ios, '8.0'

  spec.source_files   = 'CKMessagesKit/Sources/**/*.swift',
  spec.resources      = 'CKMessagesKit/Resources/**/*.xcassets', 'CKMessagesKit/Sources/**/*.xib'
  spec.frameworks     = 'UIKit', 'QuartzCore'
  spec.dependency     'CKReusable'


end
