//
//  RxBaseViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/9/24.
//

import RxSwift

class RxBaseViewController: BaseViewController {
  var disposeBag: DisposeBag = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  func bind() {
  }
}
