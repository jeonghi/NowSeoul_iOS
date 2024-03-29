//
//  PopulationDensityViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/25/24.
//

import UIKit
import SnapKit

final class PopulationDensityViewController: BaseViewController {
  private var apiClient: SeoulPublicAPIClient { .shared }
  private var congestionView: CongestionChartView = .init(frame: .zero)
  
  var areaCode: String?
  
  private var isLoading: Bool = false {
    didSet {
      if isLoading { self.activityIndicator.startAnimating() } else { self.activityIndicator.stopAnimating() }
    }
  }
  
  // MARK: Life cycle
  override func loadView() {
    view = congestionView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    callAPI()
  }
}

extension PopulationDensityViewController {
  private func callAPI() {
    if let areaCode {
      isLoading = true
      
      apiClient.fetchRealTimePopulationData(forArea: areaCode) { [weak self] res in
        DispatchQueue.main.async { [weak self] in
          guard let self else { return }
          defer { isLoading = false }
          switch res {
          case .success(let data):
            congestionView.configureChartData(with: data)
            
          case .failure(let error):
            print(error.localizedDescription)
          }
        }
      }
    }
  }
}


@available(iOS 17.0, *)
#Preview {
  let vc = PopulationDensityViewController()
  vc.areaCode = "POI002"
  return vc
}
