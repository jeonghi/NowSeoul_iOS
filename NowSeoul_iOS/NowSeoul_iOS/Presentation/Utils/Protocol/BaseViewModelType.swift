//
//  BaseViewModelType.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/9/24.
//

import Foundation
import RxSwift

protocol BaseViewModelType {
  associatedtype Input
  associatedtype Output
  
  var disposeBag: DisposeBag { get set }
  
  func transform(_ input: Input) -> Output
}
