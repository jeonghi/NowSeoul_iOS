//
//  ImageAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation
import UIKit

struct ImageAsset {
  struct Format {
    let fileExtension: String
    let convert: (ImageAsset) -> NSObjectProtocol
  }
  
  var named: String
  var bundle: Bundle
  var format: Format
  
  init(_ named: String, in bundle: Bundle, format: Format) {
    self.named = named
    self.bundle = bundle
    self.format = format
  }
}

extension ImageAsset {
  func toUIImage() -> UIImage {
    guard let uiImage = format.convert(self) as? UIImage else {
      fatalError("Failed to convert ImageAsset to UIImage")
    }
    return uiImage
  }
}

extension ImageAsset.Format {
  static let image = ImageAsset.Format(fileExtension: "assets") {
    guard let uiImage = UIImage(named: $0.named, in: $0.bundle, with: nil) else {
      fatalError("Failed to convert ImageAsset to UIImage")
    }
    return uiImage
  }
}
