//
//  AppAppearance.swift
//  NowSeoul_iOS
//
//  Created by 쩡화니 on 3/19/24.
//

import UIKit
import Then

enum AppAppearance {
  static func configure() {
    configureTabBarAppearance()
    configureNavigationBarApperance()
  }
  
  private static func configureNavigationBarApperance() {
    // UINavigationBarApperance || UINavigationBar.appearance()
    let appearance = UINavigationBarAppearance()
    
    let titleTextAttributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.asset(.primary)
    ]
    
    appearance.titleTextAttributes = titleTextAttributes
    
    let navigationBarAppearance = UINavigationBar.appearance()
    navigationBarAppearance.standardAppearance = appearance
    navigationBarAppearance.scrollEdgeAppearance = appearance
  }
  
  private static func configureTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.systemBackground
    
    let tabBarAppearance = UITabBar.appearance()
    tabBarAppearance.tintColor = UIColor.asset(.primary)
    tabBarAppearance.isTranslucent = false
    tabBarAppearance.standardAppearance = appearance
    tabBarAppearance.scrollEdgeAppearance = appearance
  }
}
