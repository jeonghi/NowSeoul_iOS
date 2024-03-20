//
//  BaseComponentConfigurable.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit

@objc protocol BaseComponentConfigurable: AnyObject {
  @objc optional func configureNavigationBar()
  @objc optional func configureToolBar()
  @objc optional func configureLayout()
  @objc optional func configureLabel()
  @objc optional func configureButton()
  @objc optional func configureTableView()
  @objc optional func configureCollectionView()
  @objc optional func configureImageView()
  @objc optional func configureTextField()
  @objc optional func configureSeachBar()
  @objc optional func configureWebView()
  @objc optional func configureMapView()
}

extension BaseComponentConfigurable where Self: UIViewController {
  func configureConfigurableMethods() {
    configureNavigationBar?()
    configureToolBar?()
    configureLayout?()
    configureLabel?()
    configureButton?()
    configureTableView?()
    configureCollectionView?()
    configureImageView?()
    configureTextField?()
    configureSeachBar?()
    configureWebView?()
    configureMapView?()
  }
}
