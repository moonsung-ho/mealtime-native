//
//  mealtimeApp.swift
//  Shared
//
//  Created by 문성호 on 2022/08/19.
//

import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds
import SwiftyJSON
import AlertToast

@main
struct mealtimeApp: App {
    @State private var selection = 1
    @AppStorage("_isFirstLaunching") var isFirstLaunch: Bool = true
    @State private var settingsPresented = false
    @State var alertPresent = false
    @State var alertBody = ""
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
                
                neisIsShit()
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
                            Text("더보기 탭에서 설정할 수 있어요.\n[개발자에게 문의하기...](https://www.facebook.com/appmealtime)").font(Font.footnote).frame(alignment: .center).multilineTextAlignment(.center)
                        }
                        Group {
                            Button(action: {
                                UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
                                isFirstLaunch.toggle()
                                settingsPresented = true
                                needToDisplaySchoolSettingsModal = true
                                MealView().needToDisplaySchoolSettingsModal = true
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
//                .toast(isPresenting: $alertPresent, duration: 10, tapToDismiss: true) {
//                    AlertToast(displayMode: .banner(.pop), type: .error(Color.red), title: "공지사항이 있어요.", subTitle: alertBody)
//                }
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
//                        }
//                }.interactiveDismissDisabled(true)
                .sheet(isPresented: $alertPresent) {
                    NavigationView {
                        VStack(alignment:.center){
                            Text("교육청 나이스의 시스템 점검으로 인해\n급식시간의 모든 서비스가 작동하지 않아요.\n궁금한 점이 있다면 [개발자에게 문의](https://www.facebook.com/appmealtime)하거나\n[나이스](https://neis.go.kr)를 참고해 주세요.")
                                .frame(alignment: .center).multilineTextAlignment(.center)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarLeading) {
                                        VStack(alignment: .leading) {
                                            Text("⚠️공지사항").font(.title).bold()
                                        }
                                    }
                                }
                        }
                    }.padding(.top, 10) .presentationDetents([.fraction(0.4)])
                }
            }
    }
    
    func neisIsShit() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startDate = dateFormatter.date(from: "2023-06-15T18:00:00+0900")
        let endDate = dateFormatter.date(from: "2023-06-20T23:59:59+0900")
        if Date().compare(startDate!) == .orderedDescending {
            if Date().compare(endDate!) == .orderedAscending {
                alertPresent.toggle()
            }
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
