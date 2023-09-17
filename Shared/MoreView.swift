//
//  MoreView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/09.
//

import SwiftUI
import StoreKit


struct MoreView: View {
    @AppStorage("after7Display") var after7Display: Bool = false
//    @AppStorage("appreviewed") var appreviewed: Bool = false
    @State var appreviewed = false
    @State var showReviewSheet = false
    @State var showContactSheet = false
    @State var showNotAppreciatedSheet = false
    
    var body: some View {
        NavigationView {
            List {
                if !appreviewed {
                    Button("⭐️ 앱 리뷰 남기기") {
                        showReviewSheet.toggle()
                        HapticManager.instance.impact(style: .medium)
                    }
                    .foregroundStyle(.foreground)
                    .alert("급식시간에 만족하셨나요?", isPresented: $showReviewSheet) {
                        Button("만족했어요") {
                            SKStoreReviewController.requestReview()
                            appreviewed = true
                        }
                        Button("만족하지 못했어요") {
                            showNotAppreciatedSheet.toggle()
                        }
                        Button("취소", role: .cancel) {}
                    }
                    .alert("만족하지 못한 이유를 알려주세요.", isPresented: $showNotAppreciatedSheet) {
                        Button("알려주기") {UIApplication.shared.open(URL(string: "https://www.facebook.com/appmealtime")!)}
                        Button("그만하기", role: .cancel) {}
                    }
                }
                NavigationLink("내 설정 확인하기") {
                    InfoView().navigationBarTitle("내 설정")
                }
                NavigationLink("공지사항") {
                    NoticeView()
                }
                NavigationLink("학교 설정") {
                    SchoolSettingsView().navigationBarTitle("학교 설정")
                }
                NavigationLink("알레르기 설정") {
                    AllergySettingsView().navigationBarTitle("알레르기 설정")
                }
                NavigationLink("학년/반 설정") {
                    GradeClassView().navigationBarTitle("학년/반 설정")
                }
                Button("문의하기") {
                    showContactSheet.toggle()
                }
                .foregroundStyle(.foreground)
                .alert("문의하기", isPresented: $showContactSheet) {
                    Button("메일") {UIApplication.shared.open(URL(string: "mailto:sungho.moon@aol.com")!)}
                    Button("Facebook") {UIApplication.shared.open(URL(string: "https://www.facebook.com/appmealtime")!)}
                    Button("GitHub") {UIApplication.shared.open(URL(string: "https://github.com/moonsung-ho/mealtime-native")!)}
                    Button("그만하기", role: .cancel) {}
                }
                Toggle("오후 8시 이후 내일 급식/시간표 표시", isOn: $after7Display)
            }.navigationBarTitle("더보기").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
