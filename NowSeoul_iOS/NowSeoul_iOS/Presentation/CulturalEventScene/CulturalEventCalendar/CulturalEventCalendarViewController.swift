//
//  CulturalEventCalendarViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import UIKit
import SnapKit
import Then
import FSCalendar
import RxSwift

final class CulturalEventCalendarViewController: RxBaseViewController {
  
  private let apiClient = SeoulPublicAPIClient.shared
  
  private lazy var mainView = CulturalEventCalendarView(frame: .zero).then {
    $0.delegate = self
  }
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let selectedDate = mainView.selectedDate {
      loadEventsForSelectedDate(selectedDate)
    }
    
    self.navigationItem.title = "문화행사"
  }
  
  func loadEventsForSelectedDate(_ date: Date) {
    // 날짜 기반으로 이벤트 로드 (API 호출)
    
    apiClient.fetchCulturalEvents(.init(startIndex: 0, endIndex: 999, date: date)) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let datas):
          self?.mainView.updateEvent(for: datas)
        case .failure(let error):
          self?.showRetryAlert(message: error.localizedDescription) {
            self?.loadEventsForSelectedDate(date)
          }
        }
      }
    }
  }
  
  private func showRetryAlert(message: String, retryAction: @escaping () -> Void) {
    let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "재시도하기", style: .default, handler: { _ in
      retryAction()
    }))
    alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

extension CulturalEventCalendarViewController: CulturalEventCalendarViewDelegate {
  func culturalEventCalendarView(_ culturalEventCalendarView: CulturalEventCalendarView, didSelect date: Date) {
    loadEventsForSelectedDate(date)
  }
}


@available(iOS 17.0, *)
#Preview {
  CulturalEventCalendarViewController().wrapToNavigationViewController()
}
