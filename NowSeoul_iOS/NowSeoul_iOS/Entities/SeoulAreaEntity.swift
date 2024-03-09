//
//  SeoulAreaEntity.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import Foundation

struct SeoulAreaEntity: Entity {
  var id: String { areaCode }
  var areaCode: String
  var polygonCoords: [[Coordinate]] // polygon 좌표들, 하나의 area에 여러개의 폴리곤이 속해 있을 수 있다.
  
  /// 다각형의 면적을 고려한 중심점 계산 공식
  static func findCentroid(for polygon: [Coordinate]) -> Coordinate {
    var area: Double = 0
    var x: Double = 0
    var y: Double = 0
    
    for (i, coord) in polygon.enumerated() {
      let nextCoord = polygon[(i + 1) % polygon.count]
      let det = Coordinate.determinant(coord, nextCoord)
      
      x += (coord.lng + nextCoord.lng) * det
      y += (coord.lat + nextCoord.lat) * det
      area += det
    }
    
    area /= 2
    let factor = 1 / (6 * area)
    return Coordinate(lng: x * factor, lat: y * factor)
  }
  
  struct Coordinate: Decodable, Hashable {
    let lng: Double
    let lat: Double
    
    /// 1) 두 좌표 pos1과 pos2 사이의 determinant (행렬식) 를 계산한다.
    static func determinant(_ pos1: Self, _ pos2: Self) -> Double {
      return pos1.lat * pos2.lng - pos2.lat * pos1.lng
    }
  }
}
