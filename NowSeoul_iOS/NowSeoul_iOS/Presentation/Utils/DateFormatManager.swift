//
//  DateFormatManager.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/8/24.
//

import Foundation

class DateFormatManager {
  static let shared = DateFormatManager()
  
  private init() {}
  
  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko-KR")
    return formatter
  }()
  
  func dateFromString(_ string: String, format: String) -> Date? {
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: string)
  }
  
  func stringFromDate(_ date: Date, format: String) -> String {
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
  }
}
