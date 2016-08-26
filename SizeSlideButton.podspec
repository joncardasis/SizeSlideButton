Pod::Spec.new do |s|
  s.name         = "SizeSlideButton"
  s.version      = "1.1.2"
  s.summary      = "A Swift UI Component for picking a size."

  s.description  = <<-DESC
  SizeSlideButton is a Swift UIControl which allows for picking a size on the control. It recognizes long presses to activate the slider and a tap for a button TouchUp event.
                   DESC

  s.homepage     = "https://github.com/joncardasis/SizeSlideButton.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author    = "Jonathan Cardasis"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/joncardasis/SizeSlideButton.git", :tag => "1.1.2" }
  s.source_files  = "SizeSlideButton.swift"
end
