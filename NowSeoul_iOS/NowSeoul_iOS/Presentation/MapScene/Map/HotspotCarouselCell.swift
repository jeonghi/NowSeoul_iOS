//
//  HotspotCarouselView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/23/24.
//

import UIKit
import Kingfisher
import SnapKit
import Then
import SkeletonView

class HotspotCarouselCell: BaseCollectionViewCell {
  private let imageView: UIImageView = .init().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
    $0.isSkeletonable = true
    $0.skeletonCornerRadius = 8
  }
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.textColor = .black
    return label
  }()
  
  private let categoryLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 12)
    label.textColor = .darkGray
    return label
  }()
  
  override func configView() {
    super.configView()
    
    self.do {
      $0.backgroundColor = .white
      $0.layer.masksToBounds = false
      $0.layer.cornerRadius = 16
      $0.layer.cornerCurve = .continuous
      $0.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
      $0.layer.shadowOpacity = 0.3
      $0.layer.shadowRadius = 2
      $0.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    addSubviews([
      imageView,
      nameLabel,
      categoryLabel
    ])
  }
  
  override func configLayout() {
    super.configLayout()
    imageView.snp.makeConstraints { make in
      make.left.top.equalToSuperview().inset(10)
      make.bottom.lessThanOrEqualToSuperview().inset(10) // 이미지 뷰의 하단을 셀의 하단과 일정 간격 두기
      make.width.equalTo(imageView.snp.height) // 너비와 높이를 같게 하여 정사각형 형태 유지
    }
    
    nameLabel.snp.makeConstraints { make in
      make.left.equalTo(imageView.snp.right).offset(10) // imageView의 오른쪽에 위치
      make.right.equalToSuperview().inset(10) // 셀의 오른쪽 가장자리와 일정 간격 유지
      make.top.equalTo(imageView) // imageView의 상단과 일치
    }
    
    categoryLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(4) // nameLabel의 하단에서 조금 떨어진 위치
      make.left.right.equalTo(nameLabel) // nameLabel과 좌우 간격 일치
      make.bottom.lessThanOrEqualToSuperview().offset(-10) // 셀의 하단과 일정 간격 유지
    }
  }
  
  func configure(with hotspot: HotspotArea) {
    nameLabel.text = hotspot.title
    categoryLabel.text = hotspot.subtitle
    
    
    imageView.kf.setImage(
      with: hotspot.imageUrl,
      options: [
        .transition(.fade(1)), // 이미지가 로드되면 페이드 효과와 함께 나타납니다.
        .cacheOriginalImage
      ]) { [weak self] result in
        guard let self else { return }
        switch result {
        case .success:
          break
        case .failure:
          break
        }
    }
  }
}
