//
//  HeaderCollectionReusableView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import UIKit
import SnapKit

class CollectionViewHeader: UICollectionReusableView {
  let searchBar = HomeSearchBar()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSearchBar()
    backgroundColor = .white
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupSearchBar() {
    addSubview(searchBar)
    searchBar.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
