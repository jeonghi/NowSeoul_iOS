//
//  AppAppearance.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit
import Then

final class AppAppearance {
  static func configure() {
    configureTabBarAppearance()
    configureNavigationBarApperance()
  }
  
  private static func configureNavigationBarApperance() {
    let navigationBarAppearance = UINavigationBar.appearance()
    
    navigationBarAppearance.tintColor = UIColor.asset(.primary)
    
    let titleTextAttributes: [NSAttributedString.Key: Any] = [
      //      .font: UIFont.asset(.title1),
      .foregroundColor: UIColor.asset(.normal)
    ]
    
    navigationBarAppearance.titleTextAttributes = titleTextAttributes
  }
  
  private static func configureTabBarAppearance() {
    let tabBarAppearance = UITabBar.appearance()
    
    // 틴트 색상 설정
    tabBarAppearance.tintColor = UIColor.asset(.primary)
    //    tabBarAppearance.unselectedItemTintColor = UIColor.asset(.deselected)
    
    // 투명도 설정
    tabBarAppearance.isTranslucent = false
    
    let appearance = UITabBarAppearance()
    
    // Customize the appearance as needed
    appearance.configureWithOpaqueBackground() // Use an opaque background
    appearance.backgroundColor = UIColor.systemBackground // Set to your preferred background color
    
    // Apply the appearance settings to both standardAppearance and scrollEdgeAppearance
    tabBarAppearance.standardAppearance = appearance
    tabBarAppearance.scrollEdgeAppearance = appearance // This is crucial for iOS 15+ to prevent transparency when scrolled
  
  }
}
