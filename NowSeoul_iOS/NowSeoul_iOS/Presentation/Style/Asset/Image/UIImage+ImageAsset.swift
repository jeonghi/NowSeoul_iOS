//
//  UIImage+ImageAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

extension UIImage {
  static func asset(_ asset: ImageAsset) -> UIImage {
    return asset.toUIImage()
  }
}
