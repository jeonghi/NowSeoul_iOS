//
//  POIDTO.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import Foundation

struct POIDTO: Decodable, DTO {
  let category, areaCode, areaName, englishName: String
  let no: Int
  
  enum CodingKeys: String, CodingKey {
    case category = "CATEGORY"
    case areaCode = "AREA_CD"
    case areaName = "AREA_NM"
    case englishName = "ENG_NM"
    case no = "NO"
  }
}
