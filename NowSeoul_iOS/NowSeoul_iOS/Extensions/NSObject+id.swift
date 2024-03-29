//
//  NSObject+id.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import Foundation

extension NSObject {
  static var identifier: String { String(describing: self) }
}
