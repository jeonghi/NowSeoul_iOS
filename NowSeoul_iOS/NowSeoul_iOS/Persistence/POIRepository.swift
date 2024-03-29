//
//  POIRepository.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import RealmSwift

final class POIRepository {
  private var realm: Realm
  
  init(realm: Realm) {
    self.realm = realm
  }
  
  func savePOI(_ poi: POIEntity) {
    let realmPOI = POIRealm(from: poi)
    try? realm.write {
      realm.add(realmPOI, update: .modified)
    }
  }
  
  // 모든 POI영역 불러오기
  func fetchAllPOIs() -> Results<POIRealm> {
    return realm.objects(POIRealm.self)
  }
}
