//
//  MDFDecoder.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/21/24.
//
import Foundation
import MapKit

final class SeoulHotspotAreaDataManager {
  static let shared = SeoulHotspotAreaDataManager()
  var hotspotAreas: [HotspotArea] = []
  private init() {
    hotspotAreas = parseGeoJSON()
  }
  private var apiClient: SeoulPublicAPIClient { .shared }
}

extension SeoulHotspotAreaDataManager {
  func parseJSON() -> [POIEntity] {
    guard let url: URL = Bundle.main.url(forResource: "seoul_hotspots_113", withExtension: "json") else {
      fatalError("Cannot find matched file")
    }
    
    var jsonObjects: [POIDTO] = .init()
    do {
      let data = try Data(contentsOf: url)
      jsonObjects = try JSONDecoder().decode([POIDTO].self, from: data)
    } catch {
      fatalError("Cannot decode json")
    }
    
    let entities: [POIEntity] = jsonObjects.map {
      POIEntity(from: $0)
    }
    
    return entities
  }
  
  func parseGeoJSON() -> [HotspotArea] {
    do {
      let hotspotFeatures = try MDFDecoder().decodeHotspotAreaFeatures()
      return hotspotFeatures
    } catch {
      dump(error)
      fatalError("Cannot decode geojson")
    }
  }
}
