//
//  Feature.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import Foundation
import MapKit

/// `Feature` 클래스는 GeoJSON 피처를 나타냅니다.
/// `Properties` 제네릭은 피처의 속성을 디코딩할 때 사용되는 Decodable 타입을 나타냅니다.
class Feature<Properties: Decodable>: NSObject, Identifiable, MDFDecodableFeature {
    /// 피처의 고유 식별자입니다. GeoJSON에서 제공하지 않는 경우 새 UUID를 생성합니다.
    let identifier: UUID
    /// 피처의 속성을 나타내며, `Properties` 타입으로 디코딩됩니다.
    let properties: Properties
    /// 피처의 지오메트리를 나타냅니다. `MKShape`와 `MKGeoJSONObject` 프로토콜을 모두 준수하는 객체의 배열입니다.
    let geometry: [MKShape & MKGeoJSONObject]
  
    /// `MKGeoJSONFeature` 객체를 사용하여 `Feature` 인스턴스를 초기화합니다.
    /// - Parameter feature: 변환할 `MKGeoJSONFeature` 객체입니다.
    /// - Throws: 속성 데이터의 디코딩에 실패하면 `MDFError.invalidData` 에러를 던집니다.
    required init(feature: MKGeoJSONFeature) throws {
        // GeoJSON 피처의 식별자를 UUID로 변환합니다.
        if let uuidString = feature.identifier, let identifier = UUID(uuidString: uuidString) {
            self.identifier = identifier
        } else {
            self.identifier = UUID() // 제공된 식별자가 없는 경우 새 UUID 생성
        }
    
        // 피처의 속성 데이터를 디코딩합니다.
        if let propertiesData = feature.properties {
            let decoder = JSONDecoder()
            properties = try decoder.decode(Properties.self, from: propertiesData)
        } else {
            throw MDFError.invalidData // 속성 데이터가 없는 경우 오류 처리
        }
    
        self.geometry = feature.geometry
    
        super.init()
    }
}
