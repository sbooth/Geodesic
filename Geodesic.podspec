Pod::Spec.new do |spec|

  spec.name         = "Geodesic"
  spec.version      = "1.0.0"
  spec.summary      = "`CLLocationCoordinate2D` extensions for geodesic calculations."

  spec.description  = <<-DESC
  `CLLocationCoordinate2D` extensions for solving geodesic problems on an ellipsoid model of the Earth.
                   DESC

  spec.homepage     = "https://github.com/sbooth/Geodesic.git"

  spec.license      = { :type => "MIT", :file => "LICENSE.txt" }

  spec.author             = { "Stephen Booth" => "me@sbooth.org" }
  spec.social_media_url   = "https://github.com/sbooth"

  spec.swift_version = '5.0'

  spec.ios.deployment_target = "13.0"
  spec.osx.deployment_target = "10.13"

  spec.source       = { :git => "https://github.com/sbooth/Geodesic.git", :tag => "v#{spec.version}" }

  spec.source_files  = "Sources/**/*.swift"

  spec.dependency "CGeodesic", "~> 2"

end
