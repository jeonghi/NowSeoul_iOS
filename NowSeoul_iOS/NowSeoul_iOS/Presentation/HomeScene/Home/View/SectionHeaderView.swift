//
//  SectionHeaderView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/25/24.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
  static let reuseIdentifier = String(describing: SectionHeaderView.self)
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 18, weight: .black)
//    label.font = UIFont.preferredFont(forTextStyle: .headline)
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupViews() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.verticalEdges.equalToSuperview()
    }
  }
  
  func configure(with title: String) {
    titleLabel.text = title
  }
}
