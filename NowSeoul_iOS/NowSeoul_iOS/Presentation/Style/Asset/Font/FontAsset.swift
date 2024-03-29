//
//  FontAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

public struct FontAsset {
  var config: FontConfig // FontFamily / Weight / Bundle / 확장자 (ex. otf, ttf...) 등
  
  var size: CGFloat // 크기
  
  var leading: Leading? // 행간
  
  public init(_ config: FontConfig, size: CGFloat, leading: Leading? = nil) {
    self.config = config
    self.size = size
    self.leading = leading
  }
}

extension FontAsset {
  public enum Leading {
    case none
    case small
    case medium
    case large
    case lineHeight(CGFloat)
    
    var value: CGFloat {
      switch self {
      case .none:
        return 0
      case .small:
        return 5.0
      case .medium:
        return 10.0
      case .large:
        return 15.0
      case .lineHeight(let value):
        return value
      }
    }
  }
}

extension FontAsset {
  public struct FontConfig {
    // weights 종류 추가
    public enum Weight: String {
      case regular
      case bold
      case light
      case medium
    }
    
    // font file type 아래 추가
    public enum FileType: String {
      case otf
      case ttf
    }
    
    var fontFamily: String
    var weight: Weight
    var bundle: Bundle?
    var fileType: FileType
    
    public init(fontFamily: String, weight: Weight, bundle: Bundle? = nil, fileType: FileType) {
      self.fontFamily = fontFamily
      self.weight = weight
      self.bundle = bundle
      self.fileType = fileType
    }
    
    public func fontName() -> String {
      return "\(fontFamily)-\(weight.rawValue.capitalized)"
    }
    
    public func fontPath() -> String {
      return "\(fontName()).\(fileType.rawValue)"
    }
  }
}
