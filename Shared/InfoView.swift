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
    
    var body: some View {
        List {
            Text("학교: \(schoolName ?? "없음")" )
            Text("학년: \(grade ?? "없음")" )
            Text("반: \(classN ?? "없음")" )
            Text(schoolCode ?? "없음")
            Text(officeCode ?? "없음")
            Text(allergy ?? "없음")
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
