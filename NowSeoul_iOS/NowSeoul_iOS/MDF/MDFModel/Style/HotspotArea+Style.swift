//
//  HotspotArea+Style.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/22/24.
//

import MapKit
import Kingfisher

extension HotspotArea: StylableFeature {
  private enum StylableCategory: Int {
    case touristZone = 0
    case culturalHeritage
    case denselyPopulatedArea
    case developedCommercialArea
    case park
    
    var tintColor: ColorAsset {
      switch self {
      case .touristZone:
        return .touristArea
      case .culturalHeritage:
        return .palacesAndCulturalHeritage
      case .denselyPopulatedArea:
        return .denselyPopulatedAreas
      case .developedCommercialArea:
        return .commercialDistricts
      case .park:
        return .parks
      }
    }
    
    var clusteringIdentifier: String {
      switch self {
      case .touristZone:
        "touristZone"
      case .culturalHeritage:
        "culturalHeritage"
      case .denselyPopulatedArea:
        "denselyPopulatedArea"
      case .developedCommercialArea:
        "developedCommercialArea"
      case .park:
        "park"
      }
    }
  }
  
  private enum StylableLevel: Int {
    case crowded = 0 // 붐빔 (100% 초과)
    case slightlyCrowded // 약간 붐빔 (75% ..<100)
    case moderate // 보통 (50% ..<75)
    case relaxed // 여유 (..<50%)
  }
  
  func configure(annotationView: MKAnnotationView) {
    if let category = StylableCategory(rawValue: self.properties.category.rawValue) {
//      switch category {
//      case .culturalHeritage:
//        
//        break
//      case .denselyPopulatedArea:
//        break
//      case .developedCommercialArea:
//        break
//      case .park:
//        break
//      case .touristZone:
//        break
//      }
      annotationView.tintColor = category.tintColor.toUIColor()
//      annotationView.canShowCallout = true
//
//      if let imageUrl {
//        downloadImage(with: imageUrl) { [weak self] res in
//          switch res {
//          case .success(let data):
//            annotationView.image = data.image
//          case .failure(let error):
//            print(error)
//          }
//        }
//      }
    } else {
      annotationView.displayPriority = .defaultLow
    }
  }
  
  func configure(overlayRenderer: MKOverlayPathRenderer) {
    if let level = StylableLevel(rawValue: self.congestionLevel.rawValue) {
      overlayRenderer.lineWidth = 2.0
      overlayRenderer.fillColor = UIColor.systemGray
    } else {
      overlayRenderer.lineWidth = 2.0
      overlayRenderer.fillColor = UIColor.systemGray
    }
    
    if let category = StylableCategory(rawValue: self.properties.category.rawValue) {
      overlayRenderer.fillColor = category.tintColor.toUIColor().withAlphaComponent(0.6)
    }
  }
  
  private func downloadImage(with url: URL, completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)?) {
    let processor = ResizingImageProcessor(
      referenceSize: .init(width: 60, height: 40),
      mode: .aspectFit
    )
    let resource = KF.ImageResource(downloadURL: url)
    KingfisherManager.shared.retrieveImage(
      with: resource,
      options: [.processor(processor)],
      completionHandler: completionHandler
    )
  }
}
