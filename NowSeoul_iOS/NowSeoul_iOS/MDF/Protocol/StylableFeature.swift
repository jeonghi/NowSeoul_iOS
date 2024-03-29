//
//  StylableFeature.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import MapKit

protocol StylableFeature {
  var geometry: [MKShape & MKGeoJSONObject] { get }
  
  func configure(overlayRenderer: MKOverlayPathRenderer)
  func configure(annotationView: MKAnnotationView)
}

extension StylableFeature {
  func configure(overlayRenderer: MKOverlayPathRenderer) {}
  func configure(annotationView: MKAnnotationView) {}
}


///// `StylableFeature` 프로토콜은 지도 상의 특징(feature)을 스타일링하기 위한 인터페이스를 정의합니다.
///// 이 프로토콜을 채택하는 객체는 지도상의 지오메트리(geometry)를 정의하고,
///// 오버레이와 어노테이션 뷰의 스타일을 설정할 수 있습니다.
// protocol StylableFeature {
//  /// 지오메트리(geometry)를 나타내는 `MKShape` 객체의 배열입니다.
//  /// `MKGeoJSONObject` 프로토콜을 준수하므로, 지오JSON 객체로도 표현될 수 있습니다.
//  var geometry: [MKShape & MKGeoJSONObject] { get }
//  
//  /// 오버레이 렌더러를 구성하기 위한 메서드입니다.
//  /// - Parameter overlayRenderer: 스타일을 적용할 `MKOverlayPathRenderer` 인스턴스입니다.
//  func configure(overlayRenderer: MKOverlayPathRenderer)
//  
//  /// 어노테이션 뷰를 구성하기 위한 메서드입니다.
//  /// - Parameter annotationView: 스타일을 적용할 `MKAnnotationView` 인스턴스입니다.
//  func configure(annotationView: MKAnnotationView)
// }
//
///// `StylableFeature` 프로토콜의 기본 구현을 제공합니다.
///// 기본 구현을 통해, 프로토콜을 채택하는 모든 타입은 이 메서드들에 대한 기본 동작을 가집니다.
///// 필요한 경우, 채택하는 타입에서 이 메서드들을 오버라이드할 수 있습니다.
// extension StylableFeature {
//  /// 오버레이 렌더러의 기본 구성을 제공합니다. 기본적으로 아무 작업도 수행하지 않습니다.
//  /// - Parameter overlayRenderer: 구성할 `MKOverlayPathRenderer` 인스턴스입니다.
//  func configure(overlayRenderer: MKOverlayPathRenderer) {
//    // 기본 구현은 비어 있습니다. 필요에 따라 오버라이드하여 사용합니다.
//  }
//  
//  /// 어노테이션 뷰의 기본 구성을 제공합니다. 기본적으로 아무 작업도 수행하지 않습니다.
//  /// - Parameter annotationView: 구성할 `MKAnnotationView` 인스턴스입니다.
//  func configure(annotationView: MKAnnotationView) {
//    // 기본 구현은 비어 있습니다. 필요에 따라 오버라이드하여 사용합니다.
//  }
// }
