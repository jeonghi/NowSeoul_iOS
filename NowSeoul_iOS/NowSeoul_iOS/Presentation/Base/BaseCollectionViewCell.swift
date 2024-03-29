//
//  BaseCollectionViewCell.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/21/24.
//

import UIKit

public class BaseCollectionViewCell: UICollectionViewCell, BaseViewConfigurable {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.prepare()
    self.configBase()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func prepare() {}
  
  func configView() {}
  
  func configLayout() {}
  
  func configHierarchy() {}
}
