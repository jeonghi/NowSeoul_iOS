//
//  SettingView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import UIKit

final class SettingView: BaseView {
  weak var delegate: SettingViewDelegate? {
    didSet {
    }
  }
}

@objc protocol SettingViewDelegate: AnyObject {
}
