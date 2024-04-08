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

final class CulturalEventCalendarViewController: BaseViewController {
  private let apiClient = SeoulPublicAPIClient.shared
  
  private lazy var calendarView = FSCalendar(frame: .zero).then {
    $0.delegate = self
    $0.dataSource = self
    $0.select(Date())
    $0.backgroundColor = .white.withAlphaComponent(0.5)
    $0.layer.cornerRadius = 16
    $0.scope = .week
  }
  
  private let contentView = UIView(frame: .zero)
  
  private var isMonthlyMode: Bool = false {
    didSet {
      if isMonthlyMode { calendarView.scope = .month } else { calendarView.scope = .week }
    }
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createCompositionalLayout()
  ).then {
    $0.register(CulturalEventListCell.self, forCellWithReuseIdentifier: CulturalEventListCell.identifier)
    $0.delegate = self
  }
  
  private lazy var dataSource: UICollectionViewDiffableDataSource<Section, CulturalEvent> = configureDataSource()
  
  var events: [CulturalEvent] = [] {
    didSet {
      var snapshot = NSDiffableDataSourceSnapshot<Section, CulturalEvent>()
      snapshot.appendSections([.main])
      snapshot.appendItems(events, toSection: .main)
      dataSource.apply(snapshot, animatingDifferences: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let selectedDate = calendarView.selectedDate {
      loadEventsForSelectedDate(selectedDate)
    }
    
    self.navigationItem.title = "문화행사"
  }
  
  // MARK: Action
  @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
    if swipe.direction == .up {
      calendarView.setScope(.week, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.view.layoutIfNeeded()
      }
    } else if swipe.direction == .down {
      calendarView.setScope(.month, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.view.layoutIfNeeded()
      }
    }
  }
  
  func configSwipeGesture() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .up
    }
    self.view.addGestureRecognizer(swipeUp)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .down
    }
    self.view.addGestureRecognizer(swipeDown)
  }
  
  func loadEventsForSelectedDate(_ date: Date) {
    // 날짜 기반으로 이벤트 로드 (API 호출)
    
    apiClient.fetchCulturalEvents(.init(startIndex: 0, endIndex: 999, date: date)) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.events = data
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

// MARK: FSCalendar
extension CulturalEventCalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
  // FSCalendarDelegate
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    loadEventsForSelectedDate(date)
  }
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendarView.snp.updateConstraints {
      $0.height.equalTo(bounds.height)
    }
    
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: CollectionView
extension CulturalEventCalendarViewController {
  private func createCompositionalLayout() -> UICollectionViewLayout {
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
    configuration.trailingSwipeActionsConfigurationProvider = { _ in
      return nil
    }
    
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }
  
  private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, CulturalEvent> {
    let dataSource: UICollectionViewDiffableDataSource<Section, CulturalEvent>
    
    dataSource = UICollectionViewDiffableDataSource<Section, CulturalEvent>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, event -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CulturalEventListCell.identifier,
        for: indexPath
      ) as? CulturalEventListCell
      
      cell?.configure(with: event)
      return cell
      })
    
    return dataSource
  }
}


extension CulturalEventCalendarViewController {
  enum Section {
    case main
  }
}

extension CulturalEventCalendarViewController {
  override func configView() {
    super.configView()
    
    calendarView.do {
      // 스타일 설정
      $0.appearance.titleFont = UIFont.systemFont(ofSize: 16)
      $0.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
      $0.appearance.weekdayFont = UIFont.systemFont(ofSize: 16)
      $0.appearance.titleDefaultColor = .black
      $0.appearance.headerTitleColor = .darkGray
      $0.appearance.weekdayTextColor = .gray
      $0.appearance.selectionColor = .blue
      $0.appearance.todayColor = .red
      $0.appearance.borderRadius = 0.5
      $0.appearance.headerMinimumDissolvedAlpha = 0.0
      $0.appearance.headerDateFormat = "MMMM yyyy"
      $0.headerHeight = 50
      $0.weekdayHeight = 50
      $0.scrollDirection = .horizontal
      $0.pagingEnabled = true
    }
    
    configSwipeGesture()
  }
  
  override func configLayout() {
    super.configLayout()
    
    calendarView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(300)
    }
    
    contentView.snp.makeConstraints {
      $0.top.equalTo(calendarView.snp.bottom).offset(20)
      $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      $0.bottomMargin.equalTo(view.safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    view.addSubview(calendarView)
    view.addSubview(contentView)
    contentView.addSubview(collectionView)
  }
}

extension CulturalEventCalendarViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard dataSource.itemIdentifier(for: indexPath) != nil else { return }
  }
}

@available(iOS 17.0, *)
#Preview {
  CulturalEventCalendarViewController().wrapToNavigationViewController()
}
