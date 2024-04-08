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
  var hotspotAreas: [HotspotAreaFeature] = []
  private init() {
    hotspotAreas = parseGeoJSON()
  }
}

extension SeoulHotspotAreaDataManager {
  func parseGeoJSON() -> [HotspotAreaFeature] {
    do {
      let hotspotFeatures = try MDFDecoder().decodeHotspotAreaFeatures()
      return hotspotFeatures
    } catch {
      dump(error)
      fatalError("Cannot decode geojson")
    }
  }
}
