//
//  MapView.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/9/24.
//

import UIKit
import MapKit
import SnapKit
import Then

final class MapView: BaseView {
  lazy var mapView = MKMapView(frame: .zero).then {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedMap(_:)))
    $0.addGestureRecognizer(tapGestureRecognizer)
  }
  
  lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewFlowLayout()).then {
    $0.isScrollEnabled = true
    $0.showsHorizontalScrollIndicator = false
  }
  
  lazy var toastContainer = UIView(frame: .zero).then {
    $0.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    $0.layer.cornerRadius = 25
    $0.clipsToBounds = true
  }
  
  lazy var toastButton = UIButton().then {
    $0.setTitle("move_to_seoul".localized, for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    $0.addTarget(self, action: #selector(tappedToastButton), for: .touchUpInside)
  }

  
  lazy var vStackView: UIStackView = .init(arrangedSubviews: [
    toastContainer,
    collectionView
  ]).then {
    $0.spacing = 20
    $0.axis = .vertical
    $0.alignment = .center
    $0.distribution = .equalCentering
  }
  
  weak var delegate: MapViewDelegate? {
    didSet {
      mapView.delegate = delegate
      mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
      mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKAnnotationView.identifier)
      
      collectionView.register(HotspotCarouselCell.self, forCellWithReuseIdentifier: HotspotCarouselCell.identifier)
      collectionView.delegate = delegate
      collectionView.dataSource = delegate
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    
    self.addSubviews([mapView, vStackView])
    
    toastContainer.addSubview(toastButton)
  }
  
  override func configLayout() {
    super.configLayout()
    
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.width.equalToSuperview()
      $0.height.equalTo(130)
    }
    
    // 컨테이너 뷰 레이아웃 설정
    toastContainer.snp.makeConstraints {
      $0.width.equalTo(200)
      $0.height.equalTo(50)
    }
    
    // toast 버튼 레이아웃 설정
    toastButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    vStackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(mapView.snp.bottom).inset(20)
    }
  }
  
  override func configView() {
    super.configView()
    collectionView.backgroundColor = .clear
    backgroundColor = .white
  }
}

extension MapView {
  // MARK: Public
  func showToast() {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.toastContainer.alpha = 1.0
    }) { [weak self] _ in
      self?.toastContainer.isHidden = false
    }
  }
  
  func hideToast() {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.toastContainer.alpha = 0.0
    }) { [weak self] _ in
      self?.toastContainer.isHidden = true
    }
  }
  
  
  // MARK: Private
  @objc private func tappedToastButton() {
    moveToSeoulCenter()
    hideToast()
  }
  
  // 어노테이션이 선택되지 않았다면, collectionView를 숨기거나 보여줌.
  @objc private func tappedMap(_ gesture: UITapGestureRecognizer) {
    if mapView.selectedAnnotations.isEmpty {
      toggleCollectionViewVisibility()
    }
  }
  
  // collectionView의 표시 상태를 토글.
  private func toggleCollectionViewVisibility() {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.collectionView.alpha = self?.collectionView.alpha == 0.0 ? 1.0 : 0.0
      self?.collectionView.isHidden.toggle()
    }) { [weak self] _ in
      self?.vStackView.layoutIfNeeded()
    }
  }
  
  private func moveToSeoulCenter() {
    var seoulCenter: CLLocationCoordinate2D { .init(latitude: 37.5665, longitude: 126.9780) }
    
    mapView.setCenter(seoulCenter, animated: true)
  }
}

// MARK: Layout 구성
extension MapView {
  private func createCollectionViewFlowLayout() -> UICollectionViewLayout {
    let layout = CarouselFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: 120)
    return layout
  }
  
  private func createCollectionViewCompositionalLayout() -> UICollectionViewLayout {
    let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalHeight(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
      group.interItemSpacing = .fixed(10)

      let section = NSCollectionLayoutSection(group: group)

      section.orthogonalScrollingBehavior = .groupPagingCentered
      section.interGroupSpacing = 10
      section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

      section.visibleItemsInvalidationHandler = { visibleItems, offset, env in
        visibleItems.forEach { item in
          // 1
          let intersectedRect = item.frame.intersection(CGRect(x: offset.x, y: offset.y, width: env.container.contentSize.width, height: item.frame.height))
          // 2
          let percentVisible = intersectedRect.width / item.frame.width
          // 3
          let scale = 0.8 + (0.2 * percentVisible)
          // 4
          item.transform = CGAffineTransform(scaleX: 0.98, y: scale)
        }

        guard let currentIndex = visibleItems.last?.indexPath.row,
              visibleItems.last?.indexPath.section == 0 else { return }
      }

      return section
    }

    layout.configuration.scrollDirection = .horizontal

    return layout
  }
}

@objc protocol MapViewDelegate: MKMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
}
