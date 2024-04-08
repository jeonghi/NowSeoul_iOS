//
//  PopulationBarChartCell.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/31/24.
//

import UIKit
import SnapKit

final class CongestionBarChartCell: BaseCollectionViewCell {
  private var congestionChatView = CongestionChartView()
  
  override func configLayout() {
    super.configLayout()
    congestionChatView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    contentView.addSubview(congestionChatView)
  }
  
  func configure(with model: SeoulPopulationDTO.Data?) {
    congestionChatView.configureChartData(with: model)
  }
}
