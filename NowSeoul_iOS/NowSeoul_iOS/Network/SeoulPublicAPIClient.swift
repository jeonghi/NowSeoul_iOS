//
//  SeoulPublicAPIClient.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/7/24.
//

import Foundation

protocol SeoulPublicAPIClientType {
  func fetchAllBaseSeoulAreaData(completion: @escaping (Result<[SeoulAreaEntity]?, Error>) -> Void)
  func fetchRealTimePopulationData(forArea areaId: Int, completion: @escaping (Result<SeoulPopulationEntity.Data?, Error>) -> Void)
  func fetchAllAreaRealTimePoulationData(forAreas areaIds: [Int], completion: @escaping (Result<[SeoulPopulationEntity.Data]?, Error>) -> Void)
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
  func fetchAllBaseSeoulAreaData(completion: @escaping (Result<[SeoulAreaEntity]?, any Error>) -> Void) {
    DispatchQueue.global().async {
      guard let url = self.baseConfigurationFileUrl.toURL() else {
        completion(.failure(NSError(domain: "No Url", code: 0)))
        return
      }
      
      
      let task = URLSession.shared.dataTask(with: url) { data, _, error in
        DispatchQueue.main.async {
          if let error {
            completion(.failure(error))
            return
          }
          
          guard let data else {
            completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
            return
          }
          
          do {
            let features = try JSONDecoder().decode(SeoulAreaDTO.Response.self, from: data).features
            
            let entities = features.map { SeoulAreaDTOMapper.toEntity($0) }
            
            completion(.success(entities))
          } catch {
            completion(.failure(error))
          }
        }
      }
      
      task.resume()
    }
  }

  func fetchRealTimePopulationData(forArea areaId: Int, completion: @escaping (Result<SeoulPopulationEntity.Data?, Error>) -> Void) {
    let key = AppConfiguration.shared.seoulPublicDataAPIKey
    
    let type = "json"
    let service = "citydata_ppltn"
    let startIndex = "1"
    let endIndex = "10"
    let areaCode = String(format: "POI%03d", areaId)
    
    let urlString = "\(baseUrl)/\(key)/\(type)/\(service)/\(startIndex)/\(endIndex)/\(areaCode)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    guard let url = urlString?.toURL() else {
      completion(.failure(NSError(domain: "No Data", code: 0)))
      return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error {
        completion(.failure(error))
        return
      }
      
      guard let data else {
        completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
        return
      }
      
      do {
        let decodedResponse = try JSONDecoder().decode(SeoulPopulationEntity.Response.self, from: data)
        guard let data = decodedResponse.citydataPpltn?.first else {
          completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
          return
        }
        completion(.success(data))
      } catch {
        completion(.failure(error))
      }
    }
    
    task.resume()
  }
  
  func fetchAllAreaRealTimePoulationData(forAreas areaIds: [Int], completion: @escaping (Result<[SeoulPopulationEntity.Data]?, any Error>) -> Void) {
    DispatchQueue.global().async {
      var list: [SeoulPopulationEntity.Data] = []
      
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
}
