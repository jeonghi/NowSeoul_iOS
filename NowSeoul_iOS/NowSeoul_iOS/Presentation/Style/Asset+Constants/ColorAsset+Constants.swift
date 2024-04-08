//
//  ColorAsset+Constants.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

// MARK: Palette
private extension ColorAsset {
  static let skycoral = ColorAsset(hex: "#F8496C")
  static let black = ColorAsset(hex: "#FFFFFF")
  static let brightBlue = ColorAsset(hex: "#00BFFF")
  static let darkRed = ColorAsset(hex: "#8B0000")
  static let purple = ColorAsset(hex: "#800080")
  static let darkBlue = ColorAsset(hex: "#00008B")
  static let green = ColorAsset(hex: "#008000")
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
