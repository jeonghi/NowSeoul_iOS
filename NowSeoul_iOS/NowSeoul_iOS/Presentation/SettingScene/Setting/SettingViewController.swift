//
//  SettingViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/20/24.
//

import UIKit
import Then

final class SettingViewController: BaseViewController {
  private lazy var mainView = SettingView().then {
    $0.delegate = self
  }
  
  override func loadView() {
    view = mainView
  }
}

extension SettingViewController: SettingViewDelegate {}
