//
//  POIEntity.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import Foundation

struct POIEntity: Entity {
  let id: Int
  let category, areaCode, areaName, englishName: String
}

extension POIEntity {
  init(from dto: POIDTO) {
    self.init(
      id: dto.no,
      category: dto.category,
      areaCode: dto.areaCode,
      areaName: dto.areaName,
      englishName: dto.englishName
    )
  }
}
