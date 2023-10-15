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
    @AppStorage("after7Display") var after7Display: Bool = false
    
    var allergies = ["없음", "난류", "우유", "메밀", "땅콩", "대두", "밀", "고등어", "게", "새우", "돼지고기", "복숭아", "토마토", "아황산염", "호두", "닭고기", "쇠고기"]
    
    var body: some View {
                    List {
                        Section {
                            NavigationLink {
                                SchoolSettingsView().navigationBarTitle("학교 설정")
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("학교")
                                    }
                                    Spacer()
                                    Text("\(schoolName ?? "학교가 설정되지 않았어요.")").foregroundStyle(.gray).fontWeight(.light)
                                }
                            }
                            NavigationLink {
                                GradeClassView().navigationBarTitle("학년/반 설정")
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("학년/반")
                                    }
                                    Spacer()
                                    Text("\(grade ?? "미설정")학년 \(classN ?? "미설정")반").foregroundStyle(.gray).fontWeight(.light)
                                }
                            }
                        } footer: {
                            Text("앱 버전: \(appVersion ?? "앱 버전을 불러올 수 없어요.")" )
                        }
                        Section {
                            Toggle("오후 8시 이후 내일 급식/시간표 표시", isOn: $after7Display)
                            NavigationLink {
                                AllergySettingsView().navigationBarTitle("알레르기 설정")
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("알레르기")
                                    }
                                    Spacer()
                                    Text("\(allergies[Int(allergy ?? "0")!] )").foregroundStyle(.gray).fontWeight(.light)
                                }
                            }
                        } header: {
                            Text("편의 기능")
                        }
                    }.onAppear {
                        schoolCode = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
                        officeCode = UserDefaults.standard.object(forKey: "officeCode") as? String
                        allergy = UserDefaults.standard.object(forKey: "allergy") as? String
                        schoolName = UserDefaults.standard.object(forKey: "schoolName") as? String
                        grade = UserDefaults.standard.object(forKey: "grade") as? String
                        classN = UserDefaults.standard.object(forKey: "class") as? String
                    }
    }
    
    struct InfoView_Previews: PreviewProvider {
        static var previews: some View {
            InfoView()
        }
    }
}
