//
//  UIViewController+hideKeyboard.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit

// MARK: 키보드 숨기기(단, 모든 클릭 시 키보드 숨기기 함수가 호출됨)
// 원하는 곳에 배치
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(
        UIViewController.dismissKeyboard
      )
    )
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}
