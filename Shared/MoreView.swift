//
//  MoreView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/09.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("정보") {
                    InfoView().navigationBarTitle("정보")
              }.navigationBarTitle("더보기")
                NavigationLink("학교 설정") {
                    SchoolSettingsView().navigationBarTitle("학교 설정")
                      }
                NavigationLink("알레르기 설정") {
                        AllergySettingsView().navigationBarTitle("알레르기 설정")
                      }
                NavigationLink("학년/반 설정") {
                        GradeClassView().navigationBarTitle("학년/반 설정")
                      }
            }
            AdBannerView()
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
