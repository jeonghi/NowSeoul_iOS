//
//  UIFont+FontAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

extension UIFont {
  static func asset(_ asset: FontAsset) -> UIFont {
    guard let font = UIFont(name: asset.config.fontName(), size: asset.size) else {
      fatalError("Failed to load the font: \(asset.config.fontName())")
    }
    return font
  }
}
