//
//  HotspotArea.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import MapKit

final class HotspotAreaFeature: Feature<HotspotAreaFeature.Properties>, MKAnnotation {
  var title: String? { properties.areaName }
  var subtitle: String? { properties.category.title }
  
  var coordinate: CLLocationCoordinate2D {
    guard let polygon = self.geometry.first(where: { $0 is MKPolygon }) as? MKPolygon else {
      return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    return polygon.coordinate
  }
  
  var imageUrl: URL? {
    "https://data.seoul.go.kr/SeoulRtd/images/hotspot/\(properties.areaName).jpg"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
      .toURL()
  }
  
  var congestionLevel: CongestionLevel = .relaxed // 혼잡도
  
  struct Properties: Decodable {
    var id: String {areaCode}
    let category: HotspotCategory
    let areaCode: String
    let areaName: String
    
    enum CodingKeys: String, CodingKey {
      case category = "CATEGORY"
      case areaCode = "AREA_CD"
      case areaName = "AREA_NM"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      category = try values.decode(HotspotCategory.self, forKey: .category)
      areaCode = try values.decode(String.self, forKey: .areaCode)
      areaName = try values.decode(String.self, forKey: .areaName)
    }
  }
}
