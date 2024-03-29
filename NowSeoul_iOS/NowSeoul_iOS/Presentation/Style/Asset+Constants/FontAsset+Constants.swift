//
//  FontAsset+Constants.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

enum FontFamily: String {
  case pretendard = "Pretendard"
}

extension FontAsset.FontConfig {
  static let bold = FontAsset.FontConfig(
    fontFamily: FontFamily.pretendard.rawValue,
    weight: .bold,
    bundle: .main,
    fileType: .otf
  )
  static let medium = FontAsset.FontConfig(
    fontFamily: FontFamily.pretendard.rawValue,
    weight: .medium,
    bundle: .main,
    fileType: .otf
  )
  static let regular = FontAsset.FontConfig(
    fontFamily: FontFamily.pretendard.rawValue,
    weight: .regular,
    bundle: .main,
    fileType: .otf
  )
}

extension FontAsset {
  static let title1 = FontAsset(.bold, size: 28)
  static let title2 = FontAsset(.bold, size: 22)
  static let headline = FontAsset(.bold, size: 18)
  static let exceptional = FontAsset(.medium, size: 16)
  static let subheadline = FontAsset(.medium, size: 16)
  static let caption = FontAsset(.medium, size: 14)
}
