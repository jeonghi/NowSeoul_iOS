//
//  PopulationDensity.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import Foundation

enum CongestionLevel: Int, CaseIterable, Decodable {
  case crowded = 0 // 붐빔 (100% 초과)
  case slightlyCrowded // 약간 붐빔 (75% ..<100)
  case moderate // 보통 (50% ..<75)
  case relaxed // 여유 (..<50%)
  
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let stringValue = try container.decode(String.self)
    
    switch stringValue {
    case "붐빔":
      self = .crowded
    case "약간 붐빔":
      self = .slightlyCrowded
    case "보통":
      self = .moderate
    case "여유":
      self = .relaxed
    default:
      self = .relaxed
    }
  }
  
  var title: String {
    switch self {
    case .crowded:
      return "붐빔"
    case .slightlyCrowded:
      return "약간 붐빔"
    case .moderate:
      return "보통"
    case .relaxed:
      return "여유"
    }
  }
}
