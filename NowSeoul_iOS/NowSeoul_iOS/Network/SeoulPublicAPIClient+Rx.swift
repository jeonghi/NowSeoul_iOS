//
//  SeoulPublicAPIClient+Rx.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/13/24.
//

import Foundation
import RxSwift


extension SeoulPublicAPIClientType {
  func fetchCulturalEventsRx(_ request: CulturalEventDTO.Request) -> Single<Result<[CulturalEvent], Error>> {
    return Single.create { single -> Disposable in
      self.fetchCulturalEvents(request) { response in
        switch response {
        case .success(let events):
          single(.success(.success(events)))
        case .failure(let error):
          single(.failure(error))
        }
      }
      return Disposables.create()
    }
  }
}
