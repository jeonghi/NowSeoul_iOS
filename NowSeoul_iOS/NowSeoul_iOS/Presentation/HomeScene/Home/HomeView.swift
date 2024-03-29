//
//  HomeView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit
import SnapKit
import Then

final class HomeView: BaseView {
  weak var delegate: HomeViewDelegate? {
    didSet {
      collectionView.delegate = delegate
      collectionView.dataSource = delegate
    }
  }
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout()).then {
    $0.backgroundColor = .clear
    $0.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeader.identifier)
    $0.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
    $0.register(PosterStyleCell.self, forCellWithReuseIdentifier: PosterStyleCell.identifier)
    $0.showsVerticalScrollIndicator = false
    $0.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
  }
  
  override func configView() {
    super.configView()
    backgroundColor = .white
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    self.addSubviews([collectionView])
  }
  
  override func configLayout() {
    super.configLayout()
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  // 레이아웃 > 섹션 > 그룹 > 아이템
  
  // 각 요소의 크기를 정해준다.
  
  
  private func createCompositionalLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6)) // Adjust for 2:3 ratio
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
      
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .continuous

      
      let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
      let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
      section.boundarySupplementaryItems = [header]
      return section
    }
  }
}

protocol HomeViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, HomeSearchBarDelegate {
}

@available(iOS 17.0, *)
#Preview {
  HomeView()
}
