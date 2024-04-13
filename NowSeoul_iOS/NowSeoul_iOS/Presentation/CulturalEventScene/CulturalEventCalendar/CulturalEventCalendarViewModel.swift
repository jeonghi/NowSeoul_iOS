//
//  CulturalEventCalendarViewModel.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/9/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CulturalEventCalendarViewModel: BaseViewModelType {
  var disposeBag: DisposeBag = .init()
  
  private var apiClient: SeoulPublicAPIClientType { SeoulPublicAPIClient.shared }
  
  struct Input {
    let selectedDate: Observable<Date>
  }
  
  struct Output {
    let events: Driver<[CulturalEvent]>
  }
  
  func transform(_ input: Input) -> Output {
    let selectedDate = input.selectedDate
    
    let errorSubject = PublishSubject<Error>()
    let eventsSubject = PublishSubject<[CulturalEvent]>()
    
    selectedDate
      .compactMap { $0 }
      .distinctUntilChanged()
      .flatMapLatest { [unowned self] date -> Single<Result<[CulturalEvent], Error>> in
        let request = CulturalEventDTO.Request(date: date)
        return self.apiClient.fetchCulturalEventsRx(request)
      }
      .subscribe(onNext: { result in
        switch result {
        case .success(let events):
          eventsSubject.onNext(events)
        case .failure(let error):
          errorSubject.onNext(error)
        }
      })
      .disposed(by: disposeBag)
    
    let eventsDriver = eventsSubject
      .asDriver(onErrorJustReturn: [])
    
    return Output(events: eventsDriver)
  }
}
