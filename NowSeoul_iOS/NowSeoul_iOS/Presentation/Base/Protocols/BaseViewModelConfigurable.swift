//
//  BaseViewModelConfigurable.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

@objc protocol BaseViewModelConfigurable: AnyObject {
  func bindViewModel()
  func bindView()
}
