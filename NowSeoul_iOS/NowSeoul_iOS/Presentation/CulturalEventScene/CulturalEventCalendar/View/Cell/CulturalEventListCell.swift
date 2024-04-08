//
//  CulturalEventListCell.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CulturalEventListCell: BaseCollectionViewCell {
  private let eventImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
    $0.backgroundColor = .secondarySystemBackground
  }
  
  private let titleLabel = UILabel().then {
    $0.numberOfLines = 2
    $0.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.textColor = .label
  }
  
  private let categoryLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .white
    $0.backgroundColor = .systemBlue
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
    $0.textAlignment = .center
  }
  
  private let districtLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    $0.textColor = .white
    $0.backgroundColor = .systemGreen
    $0.layer.cornerRadius = 5
    $0.clipsToBounds = true
    $0.textAlignment = .center
  }
  
  private let dateLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .secondaryLabel
  }
  
  private let locationLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    $0.textColor = .secondaryLabel
  }
  
  private let feeLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    $0.textColor = .systemGreen
  }
  
  override func configView() {
    backgroundColor = .systemBackground
    addShadow()
  }
  
  override func configHierarchy() {
    addSubview(eventImageView)
    addSubview(titleLabel)
    addSubview(categoryLabel)
    addSubview(districtLabel)
    addSubview(dateLabel)
    addSubview(locationLabel)
    addSubview(feeLabel)
  }
  
  override func configLayout() {
    eventImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(eventImageView.snp.width).multipliedBy(0.6)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(eventImageView.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview().inset(10)
    }
    
    categoryLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalToSuperview().inset(10)
    }
    
    districtLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(5)
      $0.leading.equalTo(categoryLabel.snp.trailing).offset(5)
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(categoryLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview().inset(10)
    }
    
    locationLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview().inset(10)
    }
    
    feeLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(5)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.lessThanOrEqualToSuperview().inset(10)
    }
  }
  
  func configure(with event: CulturalEvent) {
    titleLabel.text = event.eventName
    categoryLabel.text = " \(event.category.rawValue) "
    districtLabel.text = " \(event.district.rawValue) "
    dateLabel.text = formatDate(event.dateTime)
    locationLabel.text = event.location
    feeLabel.text = event.isFree ? "무료" : "유료: \(event.usageFee)"
    eventImageView.kf.setImage(with: event.imageUrl)
  }
  
  private func formatDate(_ dateString: String) -> String {
    return "\(dateString)"
  }
  
  private func addShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.1
    layer.shadowOffset = CGSize(width: 0, height: 2)
  }
}


@available(iOS 17.0, *)
#Preview {
  CulturalEventListCell()
}
