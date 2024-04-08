//
//  POIRealm.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import RealmSwift

class POIRealm: Object {
  @Persisted(primaryKey: true)
  var id: Int
 
  @Persisted var category: String
  @Persisted var areaCode: String
  @Persisted var areaName: String
  @Persisted var englishName: String
  
  convenience init(id: Int, category: String, areaCode: String, areaName: String, englishName: String) {
    self.init()
    self.id = id
    self.category = category
    self.areaCode = areaCode
    self.areaName = areaName
    self.englishName = englishName
  }
}

extension POIRealm {
  convenience init(from entity: POIEntity) {
    self.init(
      id: entity.id,
      category: entity.category,
      areaCode: entity.areaCode,
      areaName: entity.areaName,
      englishName: entity.englishName)
  }
}
