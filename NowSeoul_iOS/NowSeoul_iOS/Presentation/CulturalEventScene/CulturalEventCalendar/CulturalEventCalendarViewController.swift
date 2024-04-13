//
//  CulturalEventCalendarViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class CulturalEventCalendarViewController: RxBaseViewController {
  private lazy var mainView = CulturalEventCalendarView(frame: .zero)
  
  private let viewModel: CulturalEventCalendarViewModel = .init()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "문화행사"
  }
  
  override func bind() {
    super.bind()
    
    let selectedDate = mainView.rx.selectedDate
    
    // MARK: Input
    let input = CulturalEventCalendarViewModel.Input(
      selectedDate: selectedDate
    )
    
    // MARK: Output
    let output = viewModel.transform(input)
    output.events
      .drive { self.mainView.updateEvent(for: $0) }
      .disposed(by: disposeBag)
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

@available(iOS 17.0, *)
#Preview {
  CulturalEventCalendarViewController().wrapToNavigationViewController()
}
