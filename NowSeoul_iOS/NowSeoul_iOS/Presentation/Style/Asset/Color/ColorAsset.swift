//
//  ColorAsset.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

struct ColorAsset {
  enum ColorType {
    case literal
    case asset(named: String, bundler: Bundle?)
  }
  
  var red: Double
  var green: Double
  var blue: Double
  var alpha: Double
  var colorType: ColorType
  
  init(red: Double, green: Double, blue: Double, alpha: Double) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
    self.colorType = .literal
  }
  
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    
    Scanner(string: hex).scanHexInt64(&int)
    
    let red = Double((int >> 16) & 0xFF) / 255.0
    let green = Double((int >> 8) & 0xFF) / 255.0
    let blue = Double(int & 0xFF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  init(named: String, bundle: Bundle? = nil, alpha: Double = 1.0) {
    let color = UIColor(named: named, in: bundle, compatibleWith: nil)
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    color?.getRed(&red, green: &green, blue: &blue, alpha: nil)
    
    self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: alpha)
  }
}

extension ColorAsset {
  func toUIColor() -> UIColor {
    return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
  }
  
  func toCGColor() -> CGColor {
    return toUIColor().cgColor
  }
}
