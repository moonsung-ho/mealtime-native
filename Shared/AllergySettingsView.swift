//
//  AllergySettingsView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/15.
//

import SwiftUI

struct AllergySettingsView: View {
    @State private var selectedAllergy: Int = 0
    
    var body: some View {
        List{
            Picker(selection: $selectedAllergy, label: Text("알레르기가 있는 식재료 선택하기")) {
                Group{
                    Text("없음").tag(0)
                    Text("난류").tag(1)
                    Text("우유").tag(2)
                    Text("메밀").tag(3)
                    Text("땅콩").tag(4)
                    Text("대두").tag(5)
                    Text("밀").tag(6)
                    Text("고등어").tag(7)
                    Text("게").tag(8)
                }
                Group{
                    Text("새우").tag(9)
                    Text("돼지고기").tag(10)
                    Text("복숭아").tag(11)
                    Text("토마토").tag(12)
                    Text("아황산염").tag(13)
                    Text("호두").tag(14)
                    Text("닭고기").tag(15)
                    Text("쇠고기").tag(16)
                }
                Text("오징어").tag(17)
                Text("조개류(굴,전복,홍합 등)").tag(18)
            }
            .onChange(of: selectedAllergy) { newValue in
                UserDefaults.standard.set(String(selectedAllergy), forKey: "allergy")
                HapticManager.instance.notification(type: .success)
            }.onAppear{
                if UserDefaults.standard.string(forKey: "allergy") == nil {
                    UserDefaults.standard.set("0", forKey: "allergy")
                    selectedAllergy = 0
                } else {
                    selectedAllergy = Int(UserDefaults.standard.object(forKey: "allergy") as! String) ?? 0
                }
            }
        }
    }
}

struct AllergySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AllergySettingsView()
    }
}
