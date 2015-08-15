Pod::Spec.new do |s|

s.platform                 = :ios
s.ios.deployment_target    = '7.1'
s.version                  = "0.4.0"
s.name                     = "IHakulaRequest"
s.author                   = { "Wayde Sun" => "wsun191@gmail.com" }
s.homepage                 = "https://github.com/wayde191/IHakulaInfrastructure"
s.summary                  = "IHakulaRequest shoudl be prepared when you want to use all IHakula components."
s.source                = { :git => "https://github.com/wayde191/IHakulaRequest.git", :tag => "#{s.version}"}
s.license               = { :type => "MIT", :file => "LICENSE" }

s.requires_arc             = true
s.framework                = "UIKit", "Foundation", "CFNetwork", "SystemConfiguration", "MobileCoreServices", "CoreGraphics"
s.library                  = "z"

s.dependency 'IHakulaInfrastructure', '~> 0.2.0'
s.dependency 'Reachability', '~> 3.2'

s.public_header_files = "#{s.name}/#{s.name}/**/*.{h}"
s.source_files  = "#{s.name}/#{s.name}/*.{h}"

s.subspec 'MVC' do |mvc|
    mvc.dependency "#{s.name}/Network"

    mvc.source_files = "#{s.name}/#{s.name}/MVC/**/*.{h,m}"
end

s.subspec 'Network' do |nw|
    nw.dependency "#{s.name}/ASI"

    nw.source_files = "#{s.name}/#{s.name}/Network/*.{h,m}"
end

s.subspec 'ASI' do |asi|
    asi.source_files = "#{s.name}/#{s.name}/ASIRequest/*.{h,m}"
end

end