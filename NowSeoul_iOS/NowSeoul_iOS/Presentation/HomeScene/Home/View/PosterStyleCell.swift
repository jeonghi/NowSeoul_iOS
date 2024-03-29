//
//  PosterStyleCell.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/25/24.
//

import UIKit
import Kingfisher
import SnapKit

class PosterStyleCell: BaseCollectionViewCell {
  private let containerView: UIView = .init()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private let gradientView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textColor = .white
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    return label
  }()
  
  override func configView() {
    super.configView()
    containerView.layer.cornerRadius = 6
    containerView.layer.cornerCurve = .continuous
    containerView.clipsToBounds = true
    applyGradient()
  }
  
  override func configLayout() {
    super.configLayout()
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    gradientView.snp.makeConstraints { make in
      make.left.bottom.right.equalToSuperview()
      make.height.equalToSuperview().multipliedBy(0.3)
    }
    
    titleLabel.snp.makeConstraints { make in
      make.left.equalTo(gradientView.snp.left).offset(10)
      make.right.equalTo(gradientView.snp.right).offset(-10)
      make.bottom.equalTo(subtitleLabel.snp.top).offset(-4)
    }
    
    subtitleLabel.snp.makeConstraints { make in
      make.left.right.equalTo(titleLabel)
      make.bottom.equalTo(gradientView.snp.bottom).offset(-10)
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    
    addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(gradientView)
    gradientView.addSubview(titleLabel)
    gradientView.addSubview(subtitleLabel)
  }
  
  private func applyGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = gradientView.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    gradientView.layer.insertSublayer(gradientLayer, at: 0)
  }
  
  func configure(with hotspot: HotspotArea) {
    titleLabel.text = hotspot.title
    subtitleLabel.text = hotspot.subtitle
    
    imageView.kf.setImage(with: hotspot.imageUrl, options: [.transition(.fade(1)), .cacheOriginalImage])
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientView.layer.sublayers?.first?.frame = gradientView.bounds
  }
}
