//
//  InfoView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/15.
//

import SwiftUI

struct InfoView: View {
    @State var schoolCode: String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
    @State var officeCode: String? = UserDefaults.standard.object(forKey: "officeCode") as? String
    @State var allergy: String? = UserDefaults.standard.object(forKey: "allergy") as? String
    @State var schoolName: String? = UserDefaults.standard.object(forKey: "schoolName") as? String
    @State var classN: String? = UserDefaults.standard.object(forKey: "class") as? String
    @State var grade: String? = UserDefaults.standard.object(forKey: "grade") as? String
    @State var appVersion: String? = Bundle.main.infoDictionary?["CFBundleVersion"] as? String

    
    var body: some View {
        List {
            Text("\(schoolName ?? "학교가 설정되지 않았어요.")" )
            Text("\(grade ?? "미설정")학년 \(classN ?? "미설정")반" )
            Text("알레르기: \(allergy ?? "없음")" )
            Text("앱 버전: \(appVersion ?? "앱 버전을 불러올 수 없어요.")" )
            Button("개발자에게 문의하기") {
                UIApplication.shared.open(URL(string: "https://www.facebook.com/appmealtime")!)
            }.foregroundColor(Color.blue)
        }.onAppear {
            schoolCode = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
            officeCode = UserDefaults.standard.object(forKey: "officeCode") as? String
            allergy = UserDefaults.standard.object(forKey: "allergy") as? String
            schoolName = UserDefaults.standard.object(forKey: "schoolName") as? String
            grade = UserDefaults.standard.object(forKey: "grade") as? String
            classN = UserDefaults.standard.object(forKey: "class") as? String
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
