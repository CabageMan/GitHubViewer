# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

use_frameworks!

def shared_pods
  #Utilities
  pod 'KeychainAccess'

  #Networking
  pod 'Apollo'
  pod 'OAuthSwift'

  #UIKit
  pod 'TinyConstraints'
  pod 'Nuke'
  pod 'Parchment'
end

# Pods for GitHubViewer
target 'GitHubViewer' do
  # DEBUG:
    pod 'Wormholy', :configurations => ['Debug']

    shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
    end
  end
end
