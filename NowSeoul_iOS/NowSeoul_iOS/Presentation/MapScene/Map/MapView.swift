//
//  MapView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit
import MapKit
import SnapKit

class MapView: BaseView {
  let mapView: MKMapView = .init(frame: .zero)
  
  weak var delegate: MapViewDelegate? {
    didSet {
      mapView.delegate = delegate
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    addSubview(mapView)
  }
  
  override func configLayout() {
    super.configLayout()
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func configView() {
    super.configView()
    backgroundColor = .white
  }
}

@objc protocol MapViewDelegate: MKMapViewDelegate {
}

extension MapViewDelegate {
}
