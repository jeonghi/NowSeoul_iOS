//
//  MapViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit
import MapKit
import Then

final class MapViewController: BaseViewController {
  // MARK: Properties
  private lazy var mainView: MapView = MapView(frame: .zero)
  
  private var isLoading: Bool = false {
    didSet {
      if isLoading {activityIndicator.startAnimating()} else {activityIndicator.stopAnimating()}
    }
  }
  private var seoulAreas: [SeoulAreaEntity] = [] {
    didSet {
      updatePolygonsAndAnnotations()
    }
  }
  
  // MARK: Life cycle
  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    callRequest()
  }
}

extension MapViewController {
  private func callRequest() {
    isLoading = true
    SeoulPublicAPIClient.shared.fetchAllBaseSeoulAreaData { [weak self] res in
      defer { self?.isLoading = false }
      switch res {
      case .success(let seoulAreas):
        guard let seoulAreas else { return }
        self?.seoulAreas = seoulAreas
      case .failure:
        return
      }
    }
  }
}

extension MapViewController: MapViewDelegate {
  private func updatePolygonsAndAnnotations() {
    let seoulAreas: [SeoulAreaEntity] = self.seoulAreas
    
    if !mainView.mapView.annotations.isEmpty {
      mainView.mapView.removeAnnotations(mainView.mapView.annotations)
    }
    
    seoulAreas.forEach { area in
      area.polygonCoords.forEach { polygonCoords in
        let coordinates = polygonCoords.map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) }
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        mainView.mapView.addOverlay(polygon)
        
        // 중심 좌표 계산
        let centerCoord = SeoulAreaEntity.findCentroid(for: polygonCoords)
        let center = CLLocationCoordinate2D(latitude: centerCoord.lat, longitude: centerCoord.lng)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = area.areaCode
        mainView.mapView.addAnnotation(annotation)
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
      // 서울시 중심에서의 최대 허용 범위 (예: 위도 ±0.1도, 경도 ±0.1도)
      let maxSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
      // 서울시 중심에서의 최소 허용 범위 (예: 위도 ±0.01도, 경도 ±0.01도)
      let minSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      
      var newSpan = mapView.region.span
      var needAdjust = false
      
      // 최대, 최소 확대/축소 제한 확인
      if newSpan.latitudeDelta > maxSpan.latitudeDelta {
          newSpan.latitudeDelta = maxSpan.latitudeDelta
          needAdjust = true
      } else if newSpan.latitudeDelta < minSpan.latitudeDelta {
          newSpan.latitudeDelta = minSpan.latitudeDelta
          needAdjust = true
      }
      
      if newSpan.longitudeDelta > maxSpan.longitudeDelta {
          newSpan.longitudeDelta = maxSpan.longitudeDelta
          needAdjust = true
      } else if newSpan.longitudeDelta < minSpan.longitudeDelta {
          newSpan.longitudeDelta = minSpan.longitudeDelta
          needAdjust = true
      }
      
      // 필요한 경우 지도 확대/축소 범위 조정
      if needAdjust {
          let newRegion = MKCoordinateRegion(center: mapView.region.center, span: newSpan)
          mapView.setRegion(newRegion, animated: true)
      }
  }
  
  // 다각형을 지도에 표시
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if let polygon = overlay as? MKPolygon {
      let renderer = MKPolygonRenderer(polygon: polygon)
      renderer.fillColor = UIColor.darkGray.withAlphaComponent(0.2)
      renderer.strokeColor = UIColor.darkGray
      renderer.lineWidth = 3
      return renderer
    }
    
    return MKOverlayRenderer()
  }
  
  // annotation에 대한 커스텀 뷰를 제공
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "AreaCodeAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      annotationView?.image = UIImage(systemName: "wifi.circle.fill")?.withTintColor(UIColor.red)
      annotationView?.tintColor = UIColor.red
      annotationView?.canShowCallout = true
    } else {
      annotationView?.annotation = annotation
    }
    
    return annotationView
  }
}

// MARK: Base Configuration
extension MapViewController {
  override func configView() {
    mainView.delegate = self
    
    // 서울시를 잘 보여줄 수 있는 초기 span 설정
    let seoulCenter = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
    let region = MKCoordinateRegion(center: seoulCenter, latitudinalMeters: 50000, longitudinalMeters: 50000)
    mainView.mapView.setRegion(region, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  MapViewController()
}
