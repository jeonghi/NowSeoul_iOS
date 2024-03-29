//
//  ColorAsset+Constants.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

// MARK: Palette
private extension ColorAsset {
  static let skycoral = ColorAsset(named: "skycoral", bundle: .main)
  static let black = ColorAsset(hex: "#FFFFFF")
  static let brightBlue = ColorAsset(named: "brightBlue", bundle: .main)
  static let darkRed = ColorAsset(named: "darkRed", bundle: .main)
  static let purple = ColorAsset(named: "purple", bundle: .main)
  static let darkBlue = ColorAsset(named: "darkBlue", bundle: .main)
  static let green = ColorAsset(named: "green", bundle: .main)
}

// MARK: Sementic
extension ColorAsset {
  static let primary = skycoral
  static let normal = black
  
  static let touristArea = brightBlue
  static let palacesAndCulturalHeritage = darkRed
  static let denselyPopulatedAreas = purple
  static let commercialDistricts = darkBlue
  static let parks = green
}
