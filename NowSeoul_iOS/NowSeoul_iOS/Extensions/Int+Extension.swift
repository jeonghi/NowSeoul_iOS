//
//  Int+Extension.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/24/24.
//

import Foundation

extension Int {
  var thousand: Int {
    return self * 1000
  }
  
  var hundred: Int {
    return self * 100
  }
}

extension Double {
  var km: Double {
    self * 1000
  }
}
