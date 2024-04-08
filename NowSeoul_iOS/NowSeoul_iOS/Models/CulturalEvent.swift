//
//  CulturalEvent.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import Foundation

// 문화행사 정보 모델
struct CulturalEvent: Decodable, Hashable, Identifiable {
  var id: String = UUID().uuidString
  var category: Category
  var district: District
  var eventName: String
  var dateTime: String
  var location: String
  var organizationName: String
  var targetAudience: String
  var usageFee: String
  var performerInfo: String?
  var introduction: String?
  var imageUrl: URL?
  var applicationDate: String
  var type: String // 시민 또는 기관
  var startDate: String // 시작일
  var endDate: String // 종료일
  var theme: String // 테마 분류
  var latitude: Double? // 위도
  var longitude: Double? // 경도
  var isFree: Bool
  var detailUrl: URL?
  
  enum CodingKeys: String, CodingKey {
    case category = "CODENAME"
    case district = "GUNAME"
    case eventName = "TITLE"
    case dateTime = "DATE"
    case location = "PLACE"
    case organizationName = "ORG_NAME"
    case targetAudience = "USE_TRGT"
    case usageFee = "USE_FEE"
    case performerInfo = "PLAYER"
    case introduction = "PROGRAM"
    case imageUrl = "MAIN_IMG"
    case applicationDate = "RGSTDATE"
    case type = "TICKET"
    case startDate = "STRTDATE"
    case endDate = "END_DATE"
    case theme = "THEMECODE"
    case latitude = "LAT"
    case longitude = "LOT"
    case isFree = "IS_FREE"
    case detailUrl = "HMPG_ADDR"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.category = try container.decode(CulturalEvent.Category.self, forKey: .category)
    self.district = try container.decode(CulturalEvent.District.self, forKey: .district)
    self.eventName = try container.decode(String.self, forKey: .eventName)
    self.dateTime = try container.decode(String.self, forKey: .dateTime)
    self.location = try container.decode(String.self, forKey: .location)
    self.organizationName = try container.decode(String.self, forKey: .organizationName)
    self.targetAudience = try container.decode(String.self, forKey: .targetAudience)
    self.usageFee = try container.decode(String.self, forKey: .usageFee)
    self.performerInfo = try container.decodeIfPresent(String.self, forKey: .performerInfo)
    self.introduction = try container.decodeIfPresent(String.self, forKey: .introduction)
    self.imageUrl = try container.decode(String.self, forKey: .imageUrl).toURL()
    self.applicationDate = try container.decode(String.self, forKey: .applicationDate)
    self.type = try container.decode(String.self, forKey: .type)
    self.startDate = try container.decode(String.self, forKey: .startDate)
    self.endDate = try container.decode(String.self, forKey: .endDate)
    self.theme = try container.decode(String.self, forKey: .theme)
    self.latitude = try container.decodeIfPresent(String.self, forKey: .latitude)?.toDouble()
    self.longitude = try container.decodeIfPresent(String.self, forKey: .longitude)?.toDouble()
    let isFreeString = try container.decode(String.self, forKey: .isFree)
    self.isFree = isFreeString == "무료"
    self.detailUrl = try container.decode(String.self, forKey: .detailUrl).toURL()
  }
}

extension CulturalEvent {
  enum Category: String, Codable {
    case koreanMusic = "국악"
    case miscellaneous = "기타"
    case soloRecital = "독주/독창회"
    case dance = "무용"
    case musicalOpera = "뮤지컬/오페라"
    case theater = "연극"
    case movie = "영화"
    case exhibitionArt = "전시/미술"
    case festivalOther = "축제-기타"
    case festivalCultureArt = "축제-문화/예술"
    case festivalCitizenUnity = "축제-시민화합"
    case festivalNatureScenery = "축제-자연/경관"
    case festivalTraditionHistory = "축제-전통/역사"
    case concert = "콘서트"
    case classic = "클래식"
    case educationExperience = "교육 체험" // 새로운 케이스 추가
    case unknown = "분류없음" // 미확인 케이스 처리를 위한 케이스 추가
    
    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let decodedString = try container.decode(String.self)
      self = Category(rawValue: decodedString) ?? .unknown
    }
  }
  
  
  enum District: String, Decodable {
    case junggu = "중구"
    case jongno = "종로구"
    case eunpyeong = "은평구"
    case yongsan = "용산구"
    case yeongdeungpo = "영등포구"
    case yangcheon = "양천구"
    case songpa = "송파구"
    case seongbuk = "성북구"
    case seongdong = "성동구"
    case seocho = "서초구"
    case mapo = "마포구"
    case dongdaemun = "동대문구"
    case dobong = "도봉구"
    case nowon = "노원구"
    case geumcheon = "금천구"
    case guro = "구로구"
    case gwanak = "관악구"
    case gangseo = "강서구"
    case gangbuk = "강북구"
    case gangdong = "강동구"
    case gangnam = "강남구"
    case seodaemun = "서대문구"
    case dongjak = "동작구"
    case unknown = "분류없음"
    
    
    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let decodedString = try container.decode(String.self)
      self = District(rawValue: decodedString) ?? .unknown
    }
  }
}
