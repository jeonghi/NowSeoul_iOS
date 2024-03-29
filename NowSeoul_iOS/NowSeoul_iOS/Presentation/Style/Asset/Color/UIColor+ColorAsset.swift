//
//  UIColor+ColorAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

extension UIColor {
  static func asset(_ asset: ColorAsset) -> UIColor {
    return asset.toUIColor()
  }
}
