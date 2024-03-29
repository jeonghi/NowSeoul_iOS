//
//  HomeSearchBar.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit
import Then
import SnapKit

final class HomeSearchBar: BaseView {
  weak var delegate: HomeSearchBarDelegate? {
    didSet {
      searchBar.delegate = delegate
    }
  }
  
  lazy var stackView: UIStackView = .init(arrangedSubviews: [searchBarImage, searchBar])
    .then {
      $0.axis = .vertical
      $0.spacing = -15
      $0.alignment = .center
      $0.distribution = .fill
    }
  
  private lazy var searchBarImage: UIImageView = .init(frame: .zero).then {
    $0.image = UIImage.asset(.homeSearchBarImage)
    $0.contentMode = .scaleAspectFit
  }
  
  private lazy var searchBar: UISearchBar = .init().then {
    $0.barStyle = .default
    $0.backgroundImage = UIImage()
    $0.searchBarStyle = .default
    $0.backgroundColor = .white
    
    $0.searchTextField.do {
      $0.placeholder = "home_search_placeholder".localized
      $0.backgroundColor = .white
      $0.adjustsFontSizeToFitWidth = true
    }
    
    $0.layer.do {
      $0.cornerRadius = 20
      $0.borderColor = UIColor.black.cgColor
      $0.borderWidth = 1.5
      $0.masksToBounds = true
      $0.cornerCurve = .continuous
    }
  }
  
  override func configLayout() {
    super.configLayout()
    
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    searchBarImage.snp.makeConstraints {
      $0.height.equalTo(180)
    }
    
    searchBar.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(60)
    }
  }
  
  override func configHierarchy() {
    super.configHierarchy()
    addSubview(stackView)
  }
}

protocol HomeSearchBarDelegate: UISearchBarDelegate {
}

@available(iOS 17.0, *)
#Preview {
  HomeSearchBar()
}
