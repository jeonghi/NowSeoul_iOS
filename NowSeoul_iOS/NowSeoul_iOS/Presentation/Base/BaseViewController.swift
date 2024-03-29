//
//  BaseViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit
import SnapKit
import Then

class BaseViewController: UIViewController {
  var coordinator: Coordinator?
  
  /// 기본 activityIndicator. lazy 프로퍼티로, 사용시에만 초기화
  lazy var activityIndicator: UIActivityIndicatorView = .init(style: .medium).then {
    self.view.addSubview($0)
    $0.snp.makeConstraints {
      $0.center.equalTo(self.view)
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    configBase()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.backButtonTitle = ""
  }
  
  deinit {
  }
}

extension BaseViewController: BaseViewConfigurable {
  func configView() {}
  func configLayout() {}
  func configHierarchy() {}
}
