//
//  CulturalEventCalendarView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 4/9/24.
//

import UIKit
import SnapKit
import FSCalendar

final class CulturalEventCalendarView: BaseView {
  enum Section {
    case main
  }
  
  var delegate: CulturalEventCalendarViewDelegate?
  
  private lazy var calendarView = FSCalendar(frame: .zero).then {
    $0.delegate = self
    $0.dataSource = self
    $0.select(Date())
    $0.backgroundColor = .white.withAlphaComponent(0.5)
    $0.layer.cornerRadius = 16
    $0.scope = .week
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createCompositionalLayout()
  ).then {
    $0.register(CulturalEventListCell.self, forCellWithReuseIdentifier: CulturalEventListCell.identifier)
    $0.delegate = self
  }
  
  var selectedDate: Date? { calendarView.selectedDate }
  
  private lazy var dataSource: UICollectionViewDiffableDataSource<Section, CulturalEvent> = configureDataSource()
  
  private let contentView = UIView(frame: .zero)
  
  private var isMonthlyMode: Bool = false {
    didSet {
      if isMonthlyMode { calendarView.scope = .month } else { calendarView.scope = .week }
    }
  }
  
  func updateEvent(for events: [CulturalEvent]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, CulturalEvent>()
    snapshot.appendSections([.main])
    snapshot.appendItems(events, toSection: .main)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func configSwipeGesture() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .up
    }
    self.addGestureRecognizer(swipeUp)
    
    let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:))).then {
      $0.direction = .down
    }
    self.addGestureRecognizer(swipeDown)
  }
  
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
  
  override func configHierarchy() {
    super.configHierarchy()
    self.addSubview(calendarView)
    self.addSubview(contentView)
    contentView.addSubview(collectionView)
  }
  
  override func configLayout() {
    super.configLayout()
    calendarView.snp.makeConstraints {
      $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
      $0.height.equalTo(300)
    }
    
    contentView.snp.makeConstraints {
      $0.top.equalTo(calendarView.snp.bottom).offset(20)
      $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
      $0.bottomMargin.equalTo(safeAreaLayoutGuide)
    }
    
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
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
  
  // MARK: Action
  @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
    if swipe.direction == .up {
      calendarView.setScope(.week, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.layoutIfNeeded()
      }
    } else if swipe.direction == .down {
      calendarView.setScope(.month, animated: true)
      UIView.animate(withDuration: 0.5) {
        self.layoutIfNeeded()
      }
    }
  }
}

extension CulturalEventCalendarView: FSCalendarDelegate, FSCalendarDataSource {
  // FSCalendarDelegate
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    delegate?.culturalEventCalendarView(self, didSelect: date)
  }
  
  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    calendarView.snp.updateConstraints {
      $0.height.equalTo(bounds.height)
    }
    
    UIView.animate(withDuration: 0.5) {
      self.layoutIfNeeded()
    }
  }
}

extension CulturalEventCalendarView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard dataSource.itemIdentifier(for: indexPath) != nil else { return }
  }
}

@objc protocol CulturalEventCalendarViewDelegate: AnyObject {
  func culturalEventCalendarView(_ culturalEventCalendarView: CulturalEventCalendarView, didSelect date: Date)
}
