//
//  mealtimeApp.swift
//  Shared
//
//  Created by 문성호 on 2022/08/19.
//

import SwiftUI

@main
struct mealtimeApp: App {
    var body: some Scene {
        WindowGroup {
            TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
                MealView().tabItem { Text("급식") }.tag(1)
                //TimeTableView().tabItem { Text("시간표") }.tag(2)
                MoreView().tabItem { Text("더보기") }.tag(3)
            }
        }
    }
}
