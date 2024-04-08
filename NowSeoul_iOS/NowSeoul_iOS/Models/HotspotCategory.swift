//
//  HotspotCategory.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import Foundation

enum HotspotCategory: Int, Hashable, CaseIterable, Decodable {
  case touristZone = 0
  case culturalHeritage
  case denselyPopulatedArea
  case developedCommercialArea
  case park
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    
    switch stringValue {
    case "관광특구":
      self = .touristZone
    case "고궁·문화유산":
      self = .culturalHeritage
    case "인구밀집지역":
      self = .denselyPopulatedArea
    case "발달상권":
      self = .developedCommercialArea
    case "공원":
      self = .park
    default:
      self = .denselyPopulatedArea
    }
  }
  
  var title: String {
    switch self {
    case .touristZone:
      return "관광특구"
    case .culturalHeritage:
      return "고궁·문화유산"
    case .denselyPopulatedArea:
      return "인구밀집지역"
    case .developedCommercialArea:
      return "발달상권"
    case .park:
      return "공원"
    }
  }
}
