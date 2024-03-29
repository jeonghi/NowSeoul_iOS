//
//  UIView+addSubviews.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

extension UIView {
  func addSubviews(_ views: [UIView]) {
    views.forEach {
      self.addSubview($0)
    }
  }
}
