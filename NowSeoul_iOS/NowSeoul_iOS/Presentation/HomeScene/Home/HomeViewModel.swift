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
    let viewWillAppear: Observable<Void?> = .init(nil)
    let viewDidLoad: Observable<Void?> = .init(nil)
    let cellTapped: Observable<Int?> = .init(nil)
  }
  
  struct Output {
    let isLoading: Observable<Bool> = .init(false)
  }
  
  func transform() {
  }
}
