#
#  Be sure to run `pod spec lint WLReader.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "WLReader"
  spec.version      = "0.0.6"
  spec.summary      = "reader for epub or txt book"
  spec.description  = "a reader contain read book, epub and txt parse, effect, font..."
  spec.homepage     = "https://github.com/coderWeil/WLReader"
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "weil" => "weil218@163.com" }
  spec.platform     = :ios
  spec.platform     = :ios, "13.0"
  spec.source       = { :git => "https://github.com/coderWeil/WLReader.git", :tag => "#{spec.version}" }
  
  spec.subspec 'WLParser' do |ps|
    ps.source_files = "WLReader/Parser/**/*{h,m}"
    ps.dependency "AEXML"
    ps.dependency "SSZipArchive"
  end
  
  spec.subspec 'WLDataBase' do |db|
    db.source_files = "WLReader/DataBase/**/*"
    db.dependency "WCDB.swift", :modular_headers => true
  end
  
  spec.subspec 'WLDownload' do |dd|
    dd.source_files = "WLReader/Tools/**/*"
  end
  
  spec.subspec 'WLReaderCore' do |core|
    core.source_files = "WLReader/Core/**/*"
    core.dependency "WLReader/WLDownload"
    core.dependency "WLReader/WLDataBase"
    core.dependency "WLReader/WLParser"
  end
  
  
  
  spec.dependency "Moya"
  spec.dependency "RxSwift"
  spec.dependency "RxCocoa"
  spec.dependency "RxAlamofire"
  spec.dependency "Moya/RxSwift"
  spec.dependency "HandyJSON"
  spec.dependency "Kingfisher"
  spec.dependency "SnapKit"
  spec.dependency "DTCoreText", :modular_headers => true
  spec.dependency "YPImagePicker"
  spec.dependency "Popover"
  spec.dependency "Toast-Swift"
  
end
