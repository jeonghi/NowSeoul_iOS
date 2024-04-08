//
//  UIViewController+Navigation.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import UIKit

extension UIViewController {
  func wrapToNavigationViewController() -> UIViewController {
    UINavigationController(rootViewController: self)
  }
}
