//
//  BaseView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit

public class BaseView: UIView, BaseViewConfigurable {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .clear
    self.configBase()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.configBase()
  }
  
  func configView() {}
  func configLayout() {}
  func configHierarchy() {}
}
