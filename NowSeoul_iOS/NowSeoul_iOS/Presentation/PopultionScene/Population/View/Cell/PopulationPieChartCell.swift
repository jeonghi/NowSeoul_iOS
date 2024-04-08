//
//  PopulationPieChartCell.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/31/24.
//

import UIKit
import SnapKit
import Then

final class PopulationPieChartCell: BaseCollectionViewCell {
  private lazy var populationView = PopulationView()
  private lazy var genderRatioView = GenderRatioView()
  
  private lazy var hStackView = UIStackView(arrangedSubviews: [populationView, genderRatioView]).then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }
  
  override func configLayout() {
    super.configLayout()
    hStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    contentView.addSubview(hStackView)
  }
  
  func configure(with model: SeoulPopulationDTO.Data?) {
    populationView.configure(with: model)
    genderRatioView.configure(with: model)
  }
}
