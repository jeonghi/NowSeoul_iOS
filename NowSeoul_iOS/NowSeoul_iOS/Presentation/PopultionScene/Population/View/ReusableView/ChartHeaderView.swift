//
//  ChartHeaderView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/31/24.
//

import UIKit

final class ChartHeaderView: UICollectionReusableView {
  private let titleLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 20, weight: .bold)
    $0.textColor = .label
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(10)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}
