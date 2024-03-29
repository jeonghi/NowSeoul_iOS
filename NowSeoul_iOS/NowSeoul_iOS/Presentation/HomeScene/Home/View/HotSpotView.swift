//
//  HotSpotView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class HotSpotView: BaseCollectionViewCell {
  // MARK: Views
  private lazy var imageView: UIImageView = .init()
  
  // 블러 효과를 추가하기 위한 UIVisualEffectView 프로퍼티
  private lazy var blurEffectView: UIView = .init().then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.4)
  }
  
  private lazy var descriptionView: UIView = .init().then {
    $0.backgroundColor = UIColor.white
  }
  
  private lazy var subTitleLabel: UILabel = .init()
  private lazy var titleLabel: UILabel = .init()
  private lazy var statusLabel: UILabel = .init()
  
  // MARK: Base Configuration
  override func configHierarchy() {
    super.configHierarchy()
    
    addSubviews([imageView, blurEffectView, descriptionView])
  }
  
  override func configLayout() {
    super.configLayout()
    imageView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(descriptionView.snp.top)
    }
    blurEffectView.snp.makeConstraints {
      $0.edges.equalTo(imageView)
    }
    descriptionView.snp.makeConstraints { $0.height.equalTo(100)
      $0.bottom.equalToSuperview()
      $0.horizontalEdges.equalToSuperview()
    }
  }
  
  override func configView() {
    super.configView()
    applyStyles()
  }
  
  // MARK: Update View
  func configure(_ imageUrl: URL?) {
    imageView.kf.setImage(with: imageUrl)
  }
}

extension HotSpotView {
  private func applyStyles() {
    applyPosterStyle(imageView)
    applyTitleStyle(titleLabel)
    applyStatusStyle(statusLabel)
    applySubtitleStyle(subTitleLabel)
  }
  
  private func applyPosterStyle(_ imageView: UIImageView) {
    imageView.layer.cornerRadius = 16
    imageView.layer.cornerCurve = .continuous
    imageView.contentMode = .scaleAspectFill
  }
  
  private func applyTitleStyle(_ label: UILabel) {
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textAlignment = .left
  }
  
  private func applySubtitleStyle(_ label: UILabel) {
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textAlignment = .left
  }
  
  private func applyStatusStyle(_ label: UILabel) {
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    label.textAlignment = .center
  }
}

@available(iOS 17.0, *)
#Preview {
  let view = HotSpotView(frame: .zero)
  view.configure(URL(string: "https://image.k-eum.kr/seoul-hotspots/images/hotspot/33.jpg"))
  return view
}
