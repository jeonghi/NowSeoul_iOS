//
//  SeoulAreaDTO.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import Foundation

enum SeoulAreaDTO: DTO {
  struct Response: Decodable {
    let features: [Feature]
  }
  
  struct Feature: Decodable {
    let properties: Properties
    let geometry: Geometry
  }
  
  struct Properties: Decodable {
    let areaCode: String
    
    enum CodingKeys: String, CodingKey {
      case areaCode = "AREA_CD"
    }
  }
  
  struct Geometry: Decodable {
    let polygons: [[Coordinate]]
    
    enum CodingKeys: String, CodingKey {
      case polygons = "coordinates"
    }
  }
  
  struct Coordinate: Decodable, Hashable {
    let lng: Double
    let lat: Double
  }
}
