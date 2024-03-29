//
//  MDFDecoder.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import Foundation
import MapKit

enum MDFError: Error {
  case invalidType
  case invalidData
}

private struct MDFArchive {
  enum File: String {
    case seoulHotspots = "seoul_hotspots_113"
    
    var filename: String {
      return "\(self.rawValue)"
    }
  }
  
  func fileURL(for file: File) -> URL {
    guard let url = Bundle.main.url(forResource: file.filename, withExtension: "geojson") else {
      fatalError("Cannot find matched file")
    }
    return url
  }
}

final class MDFDecoder {
  private let geoJSONDecoder = MKGeoJSONDecoder()
  
  func decodeHotspotAreaFeatures() throws -> [HotspotArea] {
    let archive = MDFArchive()
    
    let hotspotAreas = try decodeFeature(HotspotArea.self, from: .seoulHotspots, in: archive)
    
    return hotspotAreas
  }
  
  private func decodeFeature<T: MDFDecodableFeature> (
    _ type: T.Type,
    from file: MDFArchive.File,
    in archive: MDFArchive
  ) throws -> [T] {
    let fileUrl: URL = archive.fileURL(for: file)
    let data = try Data(contentsOf: fileUrl)
    let geoJSONFeatures = try geoJSONDecoder.decode(data)
    guard let features = geoJSONFeatures as? [MKGeoJSONFeature] else {
        throw MDFError.invalidType
    }
    dump(features)
    let mdfFeatures = try features.map { try type.init(feature: $0) }
    return mdfFeatures
  }
}
