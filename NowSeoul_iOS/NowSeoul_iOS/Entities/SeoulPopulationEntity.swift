//
//  SeoulPopulationResponse.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/8/24.
//

import Foundation

enum SeoulPopulationEntity {
  struct Response: Decodable {
    let citydataPpltn: [SeoulPopulationEntity.Data]?
    let resultCode: String?
    let resultMessage: String?
    
    enum CodingKeys: String, CodingKey {
      case citydataPpltn = "SeoulRtd.citydata_ppltn"
      case resultCode = "RESULT.CODE"
      case resultMessage = "RESULT.MESSAGE"
    }
  }
  
  struct Data: Decodable {
    let areaName: String
    let areaCode: String
    let congestionLevel: CongestionLevel
    let congestionMessage: String
    let populationMin: Double?
    let populationMax: Double?
    let malePopulationRate: Double?
    let femalePopulationRate: Double?
    let populationTime: Date?
    let forecastPopulation: [Forecast]?
    
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
    }
    
    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      self.areaName = try container.decode(String.self, forKey: .areaName)
      self.areaCode = try container.decode(String.self, forKey: .areaCode)
      self.congestionLevel = try container.decode(SeoulPopulationEntity.CongestionLevel.self, forKey: .congestionLevel)
      self.congestionMessage = try container.decode(String.self, forKey: .congestionMessage)
      self.populationMin = try container.decodeIfPresent(String.self, forKey: .populationMin)?.toDouble()
      self.populationMax = try container.decodeIfPresent(String.self, forKey: .populationMax)?.toDouble()
      self.malePopulationRate = try container.decodeIfPresent(String.self, forKey: .malePopulationRate)?.toDouble()
      self.femalePopulationRate = try container.decodeIfPresent(String.self, forKey: .femalePopulationRate)?.toDouble()
      
      if let dateString = try container.decodeIfPresent(String.self, forKey: .populationTime),
         let date = DateFormatManager.shared.dateFromString(dateString, format: "yyyy-MM-dd HH:mm") {
        self.populationTime = date
      } else {
        self.populationTime = nil
      }
      
      self.forecastPopulation = try container.decodeIfPresent([Forecast].self, forKey: .forecastPopulation)
    }
  }
  
  struct Forecast: Decodable {
    let forecastTime: Date?
    let congestionLevel: CongestionLevel
    let populationMin: Double?
    let populationMax: Double?
    
    enum CodingKeys: String, CodingKey {
      case forecastTime = "FCST_TIME"
      case congestionLevel = "FCST_CONGEST_LVL"
      case populationMin = "FCST_PPLTN_MIN"
      case populationMax = "FCST_PPLTN_MAX"
    }
    
    init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
      
      if let dateString = try container.decodeIfPresent(String.self, forKey: .forecastTime),
         let date = DateFormatManager.shared.dateFromString(dateString, format: "yyyy-MM-dd HH:mm") {
        self.forecastTime = date
      } else {
        self.forecastTime = nil
      }
      self.congestionLevel = try container.decode(SeoulPopulationEntity.CongestionLevel.self, forKey: .congestionLevel)
      self.populationMin = try container.decodeIfPresent(String.self, forKey: .populationMin)?.toDouble()
      self.populationMax = try container.decodeIfPresent(String.self, forKey: .populationMax)?.toDouble()
    }
  }
  
  enum CongestionLevel: Int, Decodable {
    case crowded = 0
    case slightlyCrowded
    case moderate
    case relaxed
    
    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      let stringValue = try container.decode(String.self)
      
      switch stringValue {
      case "붐빔":
        self = .crowded
      case "약간 붐빔":
        self = .slightlyCrowded
      case "보통":
        self = .moderate
      case "여유":
        self = .relaxed
      default:
        self = .relaxed
      }
    }
  }
}
