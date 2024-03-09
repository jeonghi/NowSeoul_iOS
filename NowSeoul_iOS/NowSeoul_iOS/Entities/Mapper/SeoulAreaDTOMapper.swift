//
//  SeoulAreaDTOMapper.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import Foundation

final class SeoulAreaDTOMapper: DTOMapper {
  private init() {}
  static func toEntity(_ dtoFeatures: SeoulAreaDTO.Feature) -> (SeoulAreaEntity) {
    let properties = dtoFeatures.properties
    let geometry = dtoFeatures.geometry
    
    let coordinates: [[SeoulAreaEntity.Coordinate]] = geometry.polygons.map { polygon in
      polygon.map { dtoCoord in
        SeoulAreaEntity.Coordinate(lng: dtoCoord.lng, lat: dtoCoord.lat)
      }
    }
    
    return .init(
      areaCode: properties.areaCode,
      polygonCoords: coordinates
    )
  }
}
