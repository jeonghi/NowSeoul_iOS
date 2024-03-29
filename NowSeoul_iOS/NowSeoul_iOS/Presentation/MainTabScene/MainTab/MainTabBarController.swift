//
//  MainTabViewController.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit
import Then

final class MainTabBarController: UITabBarController {
  // MARK: Properties
  lazy var homeViewController = HomeViewController().then {
    $0.tabBarItem = Tab.home.tabItem
  }
  
  lazy var mapViewController = MapViewController().then {
    $0.tabBarItem = Tab.map.tabItem
  }
  
//  lazy var settingViewController = SettingViewController().then {
//    $0.tabBarItem = Tab.setting.tabItem
//  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.viewControllers = [
      homeViewController,
      mapViewController
//      settingViewController
    ]
  }
}

extension MainTabBarController {
  private enum Tab {
    case home
    case map
    case setting
    
    var localizedTitleKey: String {
      switch self {
      case .home:
        return "tab_home_title"
      case .map:
        return "tab_map_title"
      case .setting:
        return "tab_setting_title"
      }
    }
    
    var localizedTitle: String? {
      self.localizedTitleKey.localized
    }
    
    var selectedImage: UIImage? {
      switch self {
      case .home:
        return ImageAsset.homeTab
      case .map:
        return ImageAsset.mapTab
      case .setting:
        return ImageAsset.settingTab
      }
    }
    
    var image: UIImage? {
      switch self {
      case .home:
        return ImageAsset.homeTab
      case .map:
        return ImageAsset.mapTab
      case .setting:
        return ImageAsset.settingTab
      }
    }
    
    var tabItem: UITabBarItem {
      .init(title: localizedTitle, image: image, selectedImage: selectedImage)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let vc = UINavigationController(rootViewController: MainTabBarController())
  return vc
}
