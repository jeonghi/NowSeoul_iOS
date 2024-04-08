//
//  HomeViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import Foundation
import UIKit
import Then

final class HomeViewController: BaseViewController {
  private let viewModel = HomeViewModel()
  
  private lazy var mainView = HomeView().then {
    $0.delegate = self
    $0.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
  }
  
  var seoulHotspotAreaDataManager: SeoulHotspotAreaDataManager { .shared }
  private var seoulAreas = [HotspotAreaFeature]()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    seoulAreas = seoulHotspotAreaDataManager.hotspotAreas
    
    hideKeyboardWhenTappedAround()
  }
}

extension HomeViewController: BaseViewModelConfigurable {
  func bindView() {
  }
  
  func bindViewModel() {
  }
}

extension HomeViewController: HomeViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return HotspotCategory.allCases.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return seoulAreas.filter({ $0.properties.category == HotspotCategory.allCases[section] }).count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let filteredSeoulAreas = seoulAreas.filter({
      $0.properties.category == HotspotCategory.allCases[indexPath.section]
    })
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: PosterStyleCell.identifier,
      for: indexPath
    ) as? PosterStyleCell else {
      return .init()
    }
    let area = filteredSeoulAreas[indexPath.row]
    cell.configure(with: area)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let filteredSeoulAreas = seoulAreas.filter({
      $0.properties.category == HotspotCategory.allCases[indexPath.section]
    })
    let area = filteredSeoulAreas[indexPath.row]
    
    let vc = AreaDetailViewController()
    vc.navigationItem.title = area.title
    vc.areaCode = area.properties.areaCode
    self.navigationController?
      .pushViewController(vc, animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
    
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: SectionHeaderView.reuseIdentifier,
      for: indexPath
    ) as? SectionHeaderView else {
      return SectionHeaderView(frame: .zero)
    }
    let category = HotspotCategory.allCases[indexPath.section]
    headerView.configure(with: category.title)
    
    return headerView
  }
}

extension HomeViewController: UISearchBarDelegate {
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  }
}

@available(iOS 17.0, *)
#Preview {
  HomeViewController()
}
