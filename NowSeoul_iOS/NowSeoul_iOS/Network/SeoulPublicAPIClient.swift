//
//  SeoulPublicAPIClient.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/7/24.
//

import Foundation
import Alamofire

protocol SeoulPublicAPIClientType {
  func fetchRealTimePopulationData(forArea areaCode: String, completion: @escaping (Result<SeoulPopulationDTO.Data?, Error>) -> Void)
  func fetchRealTimePopulationData(forArea areaId: Int, completion: @escaping (Result<SeoulPopulationDTO.Data?, Error>) -> Void)
  func fetchAllAreaRealTimePoulationData(forAreas areaIds: [Int], completion: @escaping (Result<[SeoulPopulationDTO.Data]?, Error>) -> Void)
  func fetchCulturalEvents(_ request: CulturalEventDTO.Request, completion: @escaping (Result<[CulturalEvent], Error>) -> Void)
}

final class SeoulPublicAPIClient {
  static let shared = SeoulPublicAPIClient()
  
  private var baseConfigurationFileUrl: String {
    AppConfiguration.shared.baseConfigurationFileURL
  }
  
  private var baseUrl: String { AppConfiguration.shared.seoulPublicDataAPIBaseURL }
  
  private init() {}
}

extension SeoulPublicAPIClient: SeoulPublicAPIClientType {
  func fetchRealTimePopulationData(forArea areaCode: String, completion: @escaping (Result<SeoulPopulationDTO.Data?, Error>) -> Void) {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    
    let key = AppConfiguration.shared.seoulPublicDataAPIKey
    let type = "json"
    let service = "citydata_ppltn"
    let startIndex = "1"
    let endIndex = "10"
    let urlString = "\(baseUrl)/\(key)/\(type)/\(service)/\(startIndex)/\(endIndex)/\(areaCode)"
    /*.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""*/
    
    print(urlString)
    
    AF.request(urlString)
      .responseDecodable(of: SeoulPopulationDTO.Response.self, decoder: decoder) { res in
        switch res.result {
        case .success(let res):
          if let data = res.citydataPpltn?.first {
            completion(.success(data))
          } else {
            completion(.success(nil))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
  
  func fetchRealTimePopulationData(forArea areaId: Int, completion: @escaping (Result<SeoulPopulationDTO.Data?, Error>) -> Void) {
    let areaCode = String(format: "POI%03d", areaId)
    fetchRealTimePopulationData(forArea: areaCode, completion: completion)
  }
  
  func fetchAllAreaRealTimePoulationData(forAreas areaIds: [Int], completion: @escaping (Result<[SeoulPopulationDTO.Data]?, Error>) -> Void) {
    DispatchQueue.global().async {
      var list: [SeoulPopulationDTO.Data] = []
      
      let group = DispatchGroup()
      areaIds.forEach {
        group.enter()
        SeoulPublicAPIClient.shared.fetchRealTimePopulationData(forArea: $0) { res in
          defer {group.leave()}
          switch res {
          case .success(let data):
            guard let data else { return }
            list.append(data)
          case .failure(let error):
            dump(error)
            completion(.failure(error))
          }
        }
      }
      
      group.notify(queue: .main) {
        list.sort { $0.congestionLevel.rawValue < $1.congestionLevel.rawValue }
        completion(.success(list))
      }
    }
  }
  
  func fetchCulturalEvents(_ request: CulturalEventDTO.Request, completion: @escaping (Result<[CulturalEvent], Error>) -> Void) {
    let key = AppConfiguration.shared.seoulPublicDataAPIKey
    let type = "json"
    let service = "culturalEventInfo"
    let startIndex = request.startIndex
    let endIndex = request.endIndex
    let codeName = request.codeName
    let title = request.title
    let date = request.date
    
    let urlString = "\(baseUrl)/\(key)/\(type)/\(service)/\(startIndex)/\(endIndex)/\(codeName)/\(title)/\(date)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    print(urlString)
    
    AF.request(urlString)
      .responseDecodable(of: CulturalEventDTO.Response.self) { res in
        switch res.result {
        case .success(let res):
          print(res)
          if let events = res.culturalEventInfo?.row {
            completion(.success(events))
          } else {
            completion(.success([]))
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
    
    return
  }
}
