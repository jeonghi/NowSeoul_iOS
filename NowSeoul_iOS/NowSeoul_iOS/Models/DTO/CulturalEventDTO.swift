//
//  CulturalEventDTO.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import Foundation

enum CulturalEventDTO {
  struct Request: Encodable {
    let startIndex: Int
    let endIndex: Int
    let codeName: String
    let title: String
    var _date: Date?
    var date: String {
      guard let _date else {
        return " "
      }
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.string(from: _date)
    }
    
    init(
      startIndex: Int,
      endIndex: Int,
      codeName: CulturalEvent.Category? = nil,
      title: String? = nil,
      date: Date? = nil
    ) {
      self.startIndex = startIndex
      self.endIndex = endIndex
      self.codeName = codeName?.rawValue ?? " "
      self.title = title ?? " "
      self._date = date
    }
  }
  
  struct Response: Decodable {
    let culturalEventInfo: CulturalEventInfo?
    enum CodingKeys: String, CodingKey {
      case culturalEventInfo
    }
  }
  
  struct CulturalEventInfo: Decodable {
    let listTotalCount: Int?
    let row: [CulturalEvent]?
    let result: APIResult
    
    enum CodingKeys: String, CodingKey {
      case listTotalCount = "list_total_count"
      case result = "RESULT"
      case row
    }
  }
}

extension CulturalEventDTO {
  struct APIResult: Decodable {
    var resultCode: String
    var resultMessage: String
    
    enum CodingKeys: String, CodingKey {
      case resultCode = "CODE"
      case resultMessage = "MESSAGE"
    }
  }
}
