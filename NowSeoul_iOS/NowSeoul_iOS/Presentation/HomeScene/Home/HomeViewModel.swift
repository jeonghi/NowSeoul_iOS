//
//  HomeViewModel.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation

final class HomeViewModel {
  let input: Input
  let output: Output
  
  init() {
    input = .init()
    output = .init()
    transform()
  }
}

extension HomeViewModel: BaseViewModel {
  struct Input {
  }
  
  struct Output {
  }
  
  func transform() {
  }
}
