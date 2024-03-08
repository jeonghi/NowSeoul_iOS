//
//  String+Extension.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/8/24.
//

import Foundation

extension String {
  func toURL() -> URL? {
    URL(string: self)
  }
  
  func toDouble() -> Double? {
    Double(self)
  }
}
