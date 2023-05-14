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
    @State private var selection = 1
    @AppStorage("_isFirstLaunching") var isFirstLaunch: Bool = true
    @State private var settingsPresented = false
//    @State private var isFirstLaunch = true
    @AppStorage("needToDisplaySchoolSettingsModal") var needToDisplaySchoolSettingsModal: Bool = false
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selection) {
                MealView().tabItem { Image(systemName: "fork.knife");Text("급식") }.tag(1)
                TimeTableView().tabItem { Image(systemName: "calendar");Text("시간표") }.tag(2)
                MoreView().tabItem { Image(systemName: "ellipsis.circle.fill");Text("더보기")}.tag(3)
            }.accentColor(.yellow)
            .onAppear{
                UITabBar.appearance().backgroundColor = UIColor.systemBackground
            }
            .sheet(isPresented: $isFirstLaunch) {
                    VStack {
                        Image("LaunchIcon").resizable().scaledToFit().frame(width: 85, height: 85).cornerRadius(25).padding(.bottom, 10)
                        Text("급식시간 사용하기").font(Font.title.bold())
                        ScrollView{
                            VStack{
                                HStack{
                                    Image(systemName: "fork.knife").resizable().scaledToFit().frame(width: 40, height: 40).padding(5)
                                    VStack(alignment: .leading){
                                        Text("급식을 조회할 수 있어요").font(Font.subheadline.bold())
                                        Text("자신이 다니는 학교의 오늘과 내일,\n심지어 2주 후 급식도 확인할 수 있어요.").font(Font.subheadline).foregroundColor(Color.gray)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }.padding(.horizontal, 35).padding(.top, 20)
//                                HStack{
//                                    Image(systemName: "").resizable().scaledToFit().frame(width: 40, height: 40).padding(5)
//                                    VStack(alignment: .leading){
//                                        Text("시간표도 조회할 수 있어요.").font(Font.subheadline.bold())
//                                        Text("자신이 소속된 반의 오늘과 내일 시간표를 확인할 수 있어요.").font(Font.subheadline).foregroundColor(Color.gray)
//                                    }
//                                }.padding(.horizontal, 40).padding(.top, 25)
                                HStack(){
                                    Image(systemName: "calendar").resizable().scaledToFit().frame(width: 40, height: 40).padding(5)
                                    VStack(alignment: .leading){
                                        Text("시간표도 조회할 수 있어요").font(Font.subheadline.bold())
                                        Text("매일 아침 시간표를 확인해 보세요.").font(Font.subheadline).foregroundColor(Color.gray)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }.padding(.horizontal, 35).padding(.top, 25)
                                HStack{
                                    Image(systemName: "allergens").resizable().scaledToFit().frame(width: 40, height: 40).padding(5)
                                    VStack(alignment: .leading){
                                        Text("알레르기 식품을 경고해 드려요").font(Font.subheadline.bold())
                                        Text("알레르기가 있는 식재료를 설정하면\n그 식재료가 포함되어 있는 음식을\n빨간색으로 표시해요.").font(Font.subheadline).foregroundColor(Color.gray)
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }.padding(.horizontal, 35).padding(.top, 25)
                            }
                        }
                        VStack(alignment: .center){
                            Text("더보기 탭에서 학교와 알레르기,\n학년과 반을 설정할 수 있어요. [개발자에게 문의하기...](https://www.facebook.com/appmealtime)").font(Font.footnote).frame(alignment: .center).multilineTextAlignment(.center)
                        }
                        Group {
                            Button(action: {
                                UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
                                isFirstLaunch.toggle()
                                settingsPresented = true
                                needToDisplaySchoolSettingsModal = true
                            }) {
                                Text("시작하기")
                                    .padding(.horizontal, 35)
                                    .padding(.vertical, 15)
                                    .font(Font.title3.bold())
                                    .frame(maxWidth: UIScreen.main.bounds.width - 60)
                            }
                            .background(Color.yellow)
                            .foregroundColor(Color.white)
                            .cornerRadius(15)
                        }
                        .frame(alignment: .bottom)
//                        .padding(.top, 20)
                    }.padding(.bottom, 30).padding(.top, 50).interactiveDismissDisabled(true)
                }
                .interactiveDismissDisabled(true)
//                .sheet(isPresented: $settingsPresented) {
//                    NavigationView {
//                        SchoolSettingsView()
//                            .toolbar {
//                            ToolbarItem(placement: .navigationBarLeading) {
//                                VStack(alignment: .leading) {
//                                    Text("학교 설정하기").font(.title2).bold()
//                                    Text("다니는 학교를 검색하고 선택해 주세요.").font(Font.footnote).foregroundColor(Color(UIColor.secondaryLabel))
//                                }
//                            }
//                        }
//                    }.padding(.top, 10).interactiveDismissDisabled(true)
//                        .onDisappear {
//                            MealView().refresh()
//                        }
//                }.interactiveDismissDisabled(true)
            }
    }
    
    func schemeTransform(userInterfaceStyle:UIUserInterfaceStyle) -> ColorScheme {
        if userInterfaceStyle == .light {
            return .light
        }
        else if userInterfaceStyle == .dark {
            return .dark
        }
        return .light
    }
}
