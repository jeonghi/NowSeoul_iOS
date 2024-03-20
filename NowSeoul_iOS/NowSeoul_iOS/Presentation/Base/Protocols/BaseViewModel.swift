//
//  BaseViewModelConfigurable.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

protocol BaseViewModel {
  associatedtype Input
  associatedtype Output
  func transform()
}
