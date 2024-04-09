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
  let dummyData = CulturalEvent.init(
    id: UUID().uuidString,
    category: .classic,
    district: .dongdaemun,
    eventName: "[서울시립과학관] 2024 토요과학강연",
    dateTime: "2024-03-30~2024-11-09",
    location: "서울시립과학관 1층 사이언스홀",
    organizationName: "서울시립과학관",
    targetAudience: "과학에 관심있는 누구나",
    usageFee: "",
    applicationDate: "2024-03-06",
    type: "기관",
    startDate: "2024-03-30 00:00:00.0",
    endDate: "2024-11-09 00:00:00.0",
    theme: "기타",
    isFree: true
  )
  
  let cell = CulturalEventListCell(frame: .zero)
  cell.configure(with: dummyData)
  return cell
}
