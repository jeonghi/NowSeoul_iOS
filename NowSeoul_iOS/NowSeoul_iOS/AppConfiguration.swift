//
//  AppConfiguration.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/7/24.
//

import Foundation

final class AppConfiguration {
  
  static let shared = AppConfiguration()
  private init(){}
  
  // 서울 공공 데이터 API 키
  lazy var seoulPublicDataAPIKey: String = loadValueForKey("SEOUL_PUBLIC_DATA_API_KEY")
  
  // 서울 공공 데이터 API 기본 URL
  lazy var seoulPublicDataAPIBaseURL: String = loadValueForKey("SEOUL_PUBLIC_DATA_API_BASE_URL")
}

extension AppConfiguration {
  private func loadValueForKey(_ key: String) -> String {
    guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
      fatalError("\(key) must not be empty in plist")
    }
    return value
  }
}
