//
//  String+localizable.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

extension String {
  var localized: String {
    return NSLocalizedString(self, comment: "")
  }
  
  func localized(with: String) -> String {
    return String(format: self.localized, with)
  }
  
  func localized(number: Int) -> String {
    return String(format: self.localized, number)
  }
}
