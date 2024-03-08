//
//  ViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/7/24.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    SeoulPublicAPIClient.shared.fetchAllAreaRealTimePoulationData(forAreas: Array(1...113)) { res in
      switch res {
      case .success(let data):
        guard let data else {return}
        dump(data.count)
      case .failure(let error):
        dump(error)
      }
    }
  }
}
