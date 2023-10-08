//
//  MoreView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/09.
//

import SwiftUI
import StoreKit


struct MoreView: View {
    @State var appreviewed = false
    @State var showReviewSheet = false
    @State var showContactSheet = false
    @State var showNotAppreciatedSheet = false
    
    var body: some View {
        NavigationView {
            List {
                if !appreviewed {
                    Button {
                        showReviewSheet.toggle()
                        HapticManager.instance.impact(style: .medium)
                    } label: {
                        Label {
                            Text("앱 리뷰 남기기")
                        } icon: {
                            Image(systemName: "star.circle").foregroundStyle(.yellow)
                        }
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
                NavigationLink {
                    InfoView().navigationBarTitle("설정하기")
                } label: {
                    Label {
                        Text("설정하기")
                    } icon: {
                        Image(systemName: "gearshape.circle").foregroundStyle(.blue)
                    }
                }
                NavigationLink {
                    NoticeView()
                } label: {
                    Label {
                        Text("공지사항")
                    } icon: {
                        Image(systemName: "bell.badge.circle").foregroundStyle(.red)
                    }
                }
                Button {
                    showContactSheet.toggle()
                } label: {
                    Label {
                        Text("문의하기")
                    } icon: {
                        Image(systemName: "questionmark.circle").foregroundStyle(.orange)
                    }
                }
                .foregroundStyle(.foreground)
                .alert("문의하기", isPresented: $showContactSheet) {
                    Button("메일") {UIApplication.shared.open(URL(string: "mailto:sungho.moon@aol.com")!)}
                    Button("Facebook") {UIApplication.shared.open(URL(string: "https://www.facebook.com/appmealtime")!)}
                    Button("GitHub") {UIApplication.shared.open(URL(string: "https://github.com/moonsung-ho/mealtime-native")!)}
                    Button("그만하기", role: .cancel) {}
                }
            }.navigationBarTitle("더보기").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
