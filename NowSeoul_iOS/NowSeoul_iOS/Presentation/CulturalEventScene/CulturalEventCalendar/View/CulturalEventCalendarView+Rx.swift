//
//  CulturalEventCalendarView+Rx.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

extension Reactive where Base: CulturalEventCalendarView {
  var delegate: DelegateProxy<CulturalEventCalendarView, CulturalEventCalendarViewDelegate> {
    return ProxyDelegate.proxy(for: self.base)
  }
  
  var selectedDate: Observable<Date> {
    let proxy = ProxyDelegate.proxy(for: self.base)
    return proxy.didSelectDateSubject
  }
  
  private class ProxyDelegate: DelegateProxy<CulturalEventCalendarView,
                               CulturalEventCalendarViewDelegate>,
                               DelegateProxyType,
                               CulturalEventCalendarViewDelegate {
    let didSelectDateSubject = BehaviorSubject<Date>(value: Date())
    
    static func registerKnownImplementations() {
      self.register { ProxyDelegate(parentObject: $0, delegateProxy: self) }
    }
    
    static func currentDelegate(for object: CulturalEventCalendarView) -> CulturalEventCalendarViewDelegate? {
      return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CulturalEventCalendarViewDelegate?, to object: CulturalEventCalendarView) {
      object.delegate = delegate
    }
    
    func culturalEventCalendarView(_ culturalEventCalendarView: CulturalEventCalendarView, didSelect date: Date) {
      didSelectDateSubject.on(.next(date))
      _forwardToDelegate?.culturalEventCalendarView(culturalEventCalendarView, didSelect: date)
    }
    
    deinit {
      didSelectDateSubject.on(.completed)
    }
  }
}
