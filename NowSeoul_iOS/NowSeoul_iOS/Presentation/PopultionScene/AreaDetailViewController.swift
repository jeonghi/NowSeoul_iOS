//
//  AreaDetailViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/31/24.
//

import UIKit
import SnapKit

final class AreaDetailViewController: BaseViewController {
  enum Section: Int, CaseIterable {
    case pieChart
    case barChart
  }
  
  enum Item: Hashable {
    case population(SeoulPopulationDTO.Data)
    case congestion(SeoulPopulationDTO.Data)
  }
  
  private var apiClient: SeoulPublicAPIClient { .shared }
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: createLayout()
  )
  private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Item> = configureDataSource()
  
  var areaCode: String?
  var populationData: SeoulPopulationDTO.Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    applyInitialSnapshot()
    callAPI()
  }
  
  private func setupCollectionView() {
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
    view.addSubview(collectionView)
    
    collectionView.register(
      PopulationPieChartCell.self,
      forCellWithReuseIdentifier: PopulationPieChartCell.identifier
    )
    collectionView.register(
      CongestionBarChartCell.self,
      forCellWithReuseIdentifier: CongestionBarChartCell.identifier
    )
    collectionView.register(
      ChartHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: ChartHeaderView.identifier
    )
    
    collectionView.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Item> {
    let dataSource: UICollectionViewDiffableDataSource<Section, Item>
    
    dataSource = UICollectionViewDiffableDataSource<Section, Item>(
      collectionView: collectionView,
      cellProvider: { collectionView, indexPath, item -> UICollectionViewCell? in
        switch item {
        case .population(let data):
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PopulationPieChartCell.identifier,
            for: indexPath
          ) as? PopulationPieChartCell else {
            fatalError(
              "Cannot create new cell"
            )
          }
          cell.configure(with: data)
          self.view.layoutIfNeeded() // 레이아웃 업데이트 반영
          return cell
          
        case .congestion(let data):
          guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CongestionBarChartCell.identifier,
            for: indexPath
          ) as? CongestionBarChartCell else {
            fatalError(
              "Cannot create new cell"
            )
          }
          cell.configure(with: data)
          self.view.layoutIfNeeded() // 레이아웃 업데이트 반영
          return cell
        }
      }
    )
    
    dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader else { return nil }
      let headerView = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: ChartHeaderView.identifier,
        for: indexPath
      ) as? ChartHeaderView
      switch Section(rawValue: indexPath.section) {
      case .pieChart:
        headerView?.configure(with: "연령대별 & 성별 인구 비율")
      case .barChart:
        headerView?.configure(with: "혼잡 예측치")
      default:
        break
      }
      return headerView
    }
    
    return dataSource
  }
  
  
  private func createLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
      let sectionLayoutKind = Section(rawValue: sectionIndex)
      switch sectionLayoutKind {
      case .pieChart:
        return self.configurePieChartSection()
      case .barChart:
        return self.configureBarChartSection()
      default:
        return nil
      }
    }
    
    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.interSectionSpacing = 20 // 섹션 간 간격 설정
    layout.configuration = config
    return layout
  }
  
  private func applyInitialSnapshot() {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    snapshot.appendSections(Section.allCases)
    
    dataSource.apply(snapshot, animatingDifferences: false) // 초기 아이템은 비어 있음
  }
  
  // API 호출 후 데이터 로딩이 완료된 후 스냅샷 업데이트
  private func updateSnapshot(with data: SeoulPopulationDTO.Data?) {
    guard let data else { return }
    var snapshot = dataSource.snapshot()
    snapshot.appendItems([.population(data)], toSection: .pieChart)
    snapshot.appendItems([.congestion(data)], toSection: .barChart)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  private func configurePieChartSection() -> NSCollectionLayoutSection {
    // 아이템
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // 그룹
    let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
    
    // 섹션
    let section = NSCollectionLayoutSection(group: group)
    
    // 섹션 헤더
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func configureBarChartSection() -> NSCollectionLayoutSection {
    // 아이템
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    // 그룹
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
    
    // 섹션
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous // 가로 스크롤 가능하도록 설정
    
    // 섹션 헤더
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    
    return section
  }
  
  private func callAPI() {
    guard let areaCode = areaCode else { return }
    apiClient.fetchRealTimePopulationData(forArea: areaCode) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          self?.updateSnapshot(with: data)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let vc = AreaDetailViewController()
  vc.areaCode = "POI101"
  return vc
}
