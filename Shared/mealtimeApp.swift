//
//  mealtimeApp.swift
//  Shared
//
//  Created by 문성호 on 2022/08/19.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

@main
struct mealtimeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                MealView().tabItem { Image(systemName: "fork.knife");Text("급식") }.tag(1)
                TimeTableView().tabItem { Image(systemName: "calendar");Text("시간표") }.tag(2)
                MoreView().tabItem { Image(systemName: "ellipsis.circle.fill");Text("더보기") }.tag(3)
            }.accentColor(.yellow)
            .onAppear{
                let currentSystemScheme = UITraitCollection.current.userInterfaceStyle
                if schemeTransform(userInterfaceStyle: currentSystemScheme) == .dark {
                    UITabBar.appearance().backgroundColor = .black
                }
            }
        }
    }
    
    func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
        if userInterfaceStyle == .light {
            return .light
        }else if userInterfaceStyle == .dark {
            return .dark
        }
        return .light}
}
