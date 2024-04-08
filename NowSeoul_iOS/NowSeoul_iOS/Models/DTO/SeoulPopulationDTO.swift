//
//  SeoulPopulationResponse.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/8/24.
//

import Foundation

enum SeoulPopulationDTO {
  struct Response: Decodable, Hashable {
    let citydataPpltn: [SeoulPopulationDTO.Data]?
    let result: APIResult
    
    enum CodingKeys: String, CodingKey {
      case citydataPpltn = "SeoulRtd.citydata_ppltn"
      case result = "RESULT"
    }
  }
  
  struct APIResult: Decodable, Hashable {
    let resultCode: String?
    let resultMessage: String?
    
    enum CodingKeys: String, CodingKey {
      case resultCode = "RESULT.CODE"
      case resultMessage = "RESULT.MESSAGE"
    }
  }
  
  struct Data: Codable, Hashable {
    let areaName: String
    let areaCode: String
    let congestionLevel: CongestionLevel // 인구 밀집도
    let congestionMessage: String // 인구 밀집 관련 메시지
    let populationMin: Double?
    let populationMax: Double?
    let malePopulationRate: Double? // 남성 혼잡도 비율
    let femalePopulationRate: Double? // 여성 혼잡도 비율
    let populationTime: Date? //
    let forecastPopulation: [Forecast]?
    
    let rate0: Double?
    let rate10: Double?
    let rate20: Double?
    let rate30: Double?
    let rate40: Double?
    let rate50: Double?
    let rate60: Double?
    let rate70: Double?
    let residentPopulationRate: Double? // 거주 인구 비율
    let nonResidentPopulationRate: Double? // 비거주 인구 비율
    
    enum CodingKeys: String, CodingKey {
      case areaName = "AREA_NM"
      case areaCode = "AREA_CD"
      case congestionLevel = "AREA_CONGEST_LVL"
      case congestionMessage = "AREA_CONGEST_MSG"
      case populationMin = "AREA_PPLTN_MIN"
      case populationMax = "AREA_PPLTN_MAX"
      case malePopulationRate = "MALE_PPLTN_RATE"
      case femalePopulationRate = "FEMALE_PPLTN_RATE"
      case populationTime = "PPLTN_TIME"
      case forecastPopulation = "FCST_PPLTN"
      case rate0 = "PPLTN_RATE_0"
      case rate10 = "PPLTN_RATE_10"
      case rate20 = "PPLTN_RATE_20"
      case rate30 = "PPLTN_RATE_30"
      case rate40 = "PPLTN_RATE_40"
      case rate50 = "PPLTN_RATE_50"
      case rate60 = "PPLTN_RATE_60"
      case rate70 = "PPLTN_RATE_70"
      case residentPopulationRate = "RESNT_PPLTN_RATE"
      case nonResidentPopulationRate = "NON_RESNT_PPLTN_RATE"
    }
    
    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      self.areaName = try container.decode(String.self, forKey: .areaName)
      self.areaCode = try container.decode(String.self, forKey: .areaCode)
      self.congestionLevel = try container.decode(CongestionLevel.self, forKey: .congestionLevel)
      self.congestionMessage = try container.decode(String.self, forKey: .congestionMessage)
      self.populationMin = try container.decodeIfPresent(String.self, forKey: .populationMin)?.toDouble()
      self.populationMax = try container.decodeIfPresent(String.self, forKey: .populationMax)?.toDouble()
      self.malePopulationRate = try container.decodeIfPresent(String.self, forKey: .malePopulationRate)?.toDouble()
      self.femalePopulationRate = try container.decodeIfPresent(String.self, forKey: .femalePopulationRate)?.toDouble()
      
      self.populationTime = try container.decodeIfPresent(Date.self, forKey: .populationTime)
      
      self.forecastPopulation = try container.decodeIfPresent([Forecast].self, forKey: .forecastPopulation)
      
      rate0 = try container.decodeIfPresent(String.self, forKey: .rate0)?.toDouble()
      rate10 = try container.decodeIfPresent(String.self, forKey: .rate10)?.toDouble()
      rate20 = try container.decodeIfPresent(String.self, forKey: .rate20)?.toDouble()
      rate30 = try container.decodeIfPresent(String.self, forKey: .rate30)?.toDouble()
      rate40 = try container.decodeIfPresent(String.self, forKey: .rate40)?.toDouble()
      rate50 = try container.decodeIfPresent(String.self, forKey: .rate50)?.toDouble()
      rate60 = try container.decodeIfPresent(String.self, forKey: .rate60)?.toDouble()
      rate70 = try container.decodeIfPresent(String.self, forKey: .rate70)?.toDouble()
      residentPopulationRate = try container.decodeIfPresent(String.self, forKey: .residentPopulationRate)?.toDouble()
      
      let nonResidentPopulationRateString = try container.decodeIfPresent(
        String.self,
        forKey: .nonResidentPopulationRate
      )
      
      nonResidentPopulationRate = nonResidentPopulationRateString?.toDouble()
    }
  }
  
  struct Forecast: Codable, Hashable {
    let forecastTime: Date? // 예상 시간
    let congestionLevel: CongestionLevel // 혼잡도
    let populationMin: Double? //
    let populationMax: Double?
    
    enum CodingKeys: String, CodingKey {
      case forecastTime = "FCST_TIME"
      case congestionLevel = "FCST_CONGEST_LVL"
      case populationMin = "FCST_PPLTN_MIN"
      case populationMax = "FCST_PPLTN_MAX"
    }
    
    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      
      self.forecastTime = try container.decodeIfPresent(Date.self, forKey: .forecastTime)
      self.congestionLevel = try container.decode(CongestionLevel.self, forKey: .congestionLevel)
      self.populationMin = try container.decodeIfPresent(String.self, forKey: .populationMin)?.toDouble()
      self.populationMax = try container.decodeIfPresent(String.self, forKey: .populationMax)?.toDouble()
    }
  }
}
