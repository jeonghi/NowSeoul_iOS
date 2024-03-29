//
//  MDFDecodableFeature.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import MapKit

/// `MDFDecodableFeature` 프로토콜은 `MKGeoJSONFeature`를 통해 디코딩 가능한
/// 지도 특징(feature)를 정의하기 위한 인터페이스입니다.
/// 이 프로토콜을 채택하는 타입은 `MKGeoJSONFeature`로부터 인스턴스를 초기화할 수 있어야 합니다.
/// 이를 통해, GeoJSON 데이터를 MapKit에서 사용할 수 있는 형태로 변환하는 과정을 추상화합니다.
protocol MDFDecodableFeature {
    /// `MKGeoJSONFeature` 객체를 사용하여 초기화하는 생성자입니다.
    /// GeoJSON 피처를 해당 타입의 인스턴스로 변환하는 로직을 구현해야 합니다.
    ///
    /// - Parameter feature: 디코딩할 `MKGeoJSONFeature` 객체입니다.
    /// - Throws: 디코딩 과정에서 발생할 수 있는 에러를 던집니다.
    ///           구현하는 타입에 따라, 다양한 디코딩 관련 에러를 정의하고 처리할 수 있습니다.
    init(feature: MKGeoJSONFeature) throws
}
