
Pod::Spec.new do |s|
  s.name         = "RNPlayAudio"
  s.version      = "1.0.0"
  s.summary      = "RNPlayAudio"
  s.description  = <<-DESC
                  RNPlayAudio
                   DESC
  s.homepage     = "https://github.com/ananevam/react-native-play-audio"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNPlayAudio.git", :tag => "master" }
  s.source_files  = "RNPlayAudio/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  
