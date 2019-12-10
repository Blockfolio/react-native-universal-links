require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-universal-links"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-universal-links
                   DESC
  s.homepage     = "https://github.com/Blockfolio/react-native-universal-links"
  s.license      = "MIT"
  # s.license    = { :type => "MIT", :file => "FILE_LICENSE" }
  s.authors      = { "Taylor Johnson" => "taylor@blockfolio.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/Blockfolio/react-native-universal-links.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  # ...
  # s.dependency "..."
end

