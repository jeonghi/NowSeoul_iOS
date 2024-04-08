//
//  MapViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit
import MapKit
import SnapKit
import Then

final class MapViewController: BaseViewController {
  // MARK: Properties
  private lazy var mainView: MapView = MapView(frame: .zero)
  
  var seoulCenter: CLLocationCoordinate2D { .init(latitude: 37.5665, longitude: 126.9780) }
  
  var seoulRegion: MKCoordinateRegion {
    .init(center: seoulCenter, latitudinalMeters: 50000, longitudinalMeters: 50000)
  }
  
  var seoulHotspotAreaDataManager: SeoulHotspotAreaDataManager { .shared }
  
  private var isLoading: Bool = false {
    didSet {
      if isLoading {activityIndicator.startAnimating()} else {activityIndicator.stopAnimating()}
    }
  }
  
  private var seoulAreas = [HotspotArea]()
  private var currOverlays = [MKOverlay]()
  private var currAnnotations = [MKAnnotation]()
  
  // MARK: Life cycle
  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateMapView {
      seoulAreas.removeAll()
      seoulAreas = seoulHotspotAreaDataManager.hotspotAreas
      seoulAreas.forEach { seoulArea in
        if let polygon = seoulArea.geometry.first as? MKPolygon {
          currOverlays.append(polygon)
        }
      }
      currAnnotations.append(contentsOf: seoulAreas)
    }
  }
  
  
  private func updateMapView(_ block: () -> Void) {
    mainView.mapView.removeOverlays(currOverlays)
    mainView.mapView.removeAnnotations(currAnnotations)
    currOverlays.removeAll()
    currAnnotations.removeAll()
    
    block()
    
    mainView.mapView.addOverlays(self.currOverlays)
    mainView.mapView.addAnnotations(self.currAnnotations)
  }
}

extension MapViewController: MapViewDelegate {
  func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    // 서울 중심에서 최대 허용 거리 (20km)
    let maxDistance = 20.0.km
    
    let currentLocation = CLLocation(
      latitude: mapView.centerCoordinate.latitude,
      longitude: mapView.centerCoordinate.longitude
    )
    
    let seoulLocation = CLLocation(latitude: seoulCenter.latitude, longitude: seoulCenter.longitude)
    
    let distance = currentLocation.distance(from: seoulLocation)
    
    if distance > maxDistance {
      mainView.showToast()
    } else {
      mainView.hideToast()
    }
  }
  
  // 다각형을 지도에 표시
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let shape = overlay as? (MKShape & MKGeoJSONObject),
          let feature = seoulAreas.first(where: {
            $0.geometry.contains(where: { $0 == shape })
          }) else {
      return MKOverlayRenderer(overlay: overlay)
    }
    
    let renderer: MKOverlayPathRenderer
    switch overlay {
    case is MKMultiPolygon:
      renderer = MKMultiPolygonRenderer(overlay: overlay)
    case is MKPolygon:
      renderer = MKPolygonRenderer(overlay: overlay)
    case is MKMultiPolyline:
      renderer = MKMultiPolylineRenderer(overlay: overlay)
    case is MKPolyline:
      renderer = MKPolylineRenderer(overlay: overlay)
    default:
      return MKOverlayRenderer(overlay: overlay)
    }
    
    feature.configure(overlayRenderer: renderer)
    return renderer
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation {
      return nil
    }
    
    if let stylableFeature = annotation as? StylableFeature {
      if stylableFeature is HotspotArea {
        let annotationView = MKMarkerAnnotationView(
          annotation: annotation,
          reuseIdentifier: MKMarkerAnnotationView.identifier
        )
        annotationView.annotation = annotation
        stylableFeature.configure(annotationView: annotationView)
        return annotationView
      }
    }
    
    return nil
    /*
     //    guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation) as? CustomAnnotationView else {
     //      return nil
     //    }
     
     //    annotationView.configure(for: annotation)
     //    return annotationView
     
     //    if let clusterAnnotation = annotation as? MKClusterAnnotation {
     //      // 클러스터 어노테이션에 대한 처리
     //      let identifier = "Cluster"
     //      var view: MKAnnotationView
     //      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
     //        dequeuedView.annotation = clusterAnnotation
     //        view = dequeuedView
     //      } else {
     //        view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
     //        // 클러스터 뷰 커스터마이징
     //      }
     //      return view
     //    } else {
     //      // 일반 어노테이션에 대한 처리
     //      let identifier = "Annotation"
     //      var view: MKMarkerAnnotationView
     //      if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
     //        dequeuedView.annotation = annotation
     //        view = dequeuedView
     //      } else {
     //        view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
     //        view.clusteringIdentifier = "cluster"
     //        view.image = UIImage(systemName: "mappin")
     //        // 어노테이션 뷰 커스터마이징
     //      }
     //      return view
     //    }
     */
  }
  
  func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    mapView.setUserTrackingMode(.followWithHeading, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    view.displayPriority = .defaultLow
    view.selectedZPriority = .min
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let annotation = view.annotation as? HotspotArea else { return }
    
    let coordinate = annotation.coordinate
    mapView.setCenter(coordinate, animated: true)
    
    view.displayPriority = .defaultHigh
    view.selectedZPriority = .max
    
    guard let index = seoulAreas.firstIndex(where: { $0 == annotation }) else {
      return
    }
    
    // 컬렉션 뷰의 현재 중앙에 표시되는 셀의 인덱스
    let visibleRect = CGRect(origin: mainView.collectionView.contentOffset, size: mainView.collectionView.bounds.size)
    let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
    guard let visibleIndexPath = mainView.collectionView.indexPathForItem(at: visiblePoint) else {
      return
    }
    
    // 현재 중앙에 있는 셀의 인덱스와 선택된 어노테이션의 인덱스가 다른 경우에만 스크롤
    // 애니메이션 적용시 부자연스러워 미적용
    if visibleIndexPath.row != index {
      mainView.collectionView.scrollToItem(
        at: IndexPath(item: index, section: 0),
        at: .centeredHorizontally,
        animated: false
      )
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: HotspotCarouselCell.identifier,
      for: indexPath
    ) as? HotspotCarouselCell else {
      return .init()
    }
    let hotspot = seoulAreas[indexPath.row]
    cell.configure(with: hotspot)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    seoulAreas.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let hotspot = seoulAreas[indexPath.row]
    let vc = PopulationDensityViewController()
    vc.areaCode = hotspot.properties.areaCode
    self.present(vc, animated: true)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    updateCenterCard()
  }
  
  private func updateCenterCard() {
    // mainView.collectionView.center
    // UIView.center는 UIView의 SuperView의 좌표계 기준으로 좌표를 반환한다.
    // mainView.vStackView 좌표 시스템의 포인트를 구체적인 뷰의 좌표 시스템으로 변환한다.
    // 기준좌표계 뷰.(바꿀녀석, to: 바꿀좌표계 뷰)
    // 바꿀녀석은
    let center = mainView.vStackView.convert(
      mainView.collectionView.center,
      to: mainView.collectionView
    )
    // 그래서 UIView의 vStackView좌표계에 속한. center 좌표를, 그 자체적인 좌표로 변환시킨다.
    if let centerIndexPath = mainView.collectionView.indexPathForItem(at: center) {
      centerCardChanged(centerIndexPath)
    }
  }
  
  private func centerCardChanged(_ centerIndexPath: IndexPath) {
    let hotspot = seoulAreas[centerIndexPath.row]
    print(hotspot)
    let coordinate = hotspot.coordinate
    mainView.mapView.setCenter(coordinate, animated: true)
    if let annotation = findAnnotationByCoordinate(coordinate) {
      mainView.mapView.selectAnnotation(annotation, animated: true)
    }
  }
  
  private func findAnnotationByCoordinate(_ coordinate: CLLocationCoordinate2D) -> MKAnnotation? {
    return mainView.mapView.annotations.first { annotation in
      annotation.coordinate.latitude == coordinate.latitude && annotation.coordinate.longitude == coordinate.longitude
    }
  }
}

// MARK: Base Configuration
extension MapViewController {
  override func configView() {
    mainView.delegate = self
    mainView.mapView.setRegion(seoulRegion, animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  MapViewController()
}
