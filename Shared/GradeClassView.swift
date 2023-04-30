//
//  GradeClassView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/15.
//

import SwiftUI
import SwiftyJSON

struct GradeClassView: View {
    @State var selectedClass: Int = Int(UserDefaults.standard.string(forKey: "class") ?? "1") ?? 1
    @State var selectedGrade: Int = Int(UserDefaults.standard.string(forKey: "grade") ?? "1") ?? 1
    @State var schoolName:String? = (UserDefaults.standard.object(forKey: "schoolName") as? String)
    @State var maxClass: Int = 1
    @State var isNextPageActive = false
    @State var alertPresent = false
    
    var body: some View {
        List {
            Picker(selection: $selectedGrade, label: Text("학년 선택")) {
                if schoolName != nil {
                    if ((UserDefaults.standard.object(forKey: "schoolName") as? String)!.contains("초등학교")){
                        Button("1학년") {
                            UserDefaults.standard.set("1", forKey: "grade")
                        }.tag(1)
                        Button("2학년") {
                            UserDefaults.standard.set("2", forKey: "grade")
                        }.tag(2)
                        Button("3학년") {
                            UserDefaults.standard.set("3", forKey: "grade")
                        }.tag(3)
                        Button("4학년") {
                            UserDefaults.standard.set("4", forKey: "grade")
                        }.tag(4)
                        Button("5학년") {
                            UserDefaults.standard.set("5", forKey: "grade")
                        }.tag(5)
                        Button("6학년") {
                            UserDefaults.standard.set("6", forKey: "grade")
                        }.tag(6)
                    } else {
                        Button("1학년") {
                            UserDefaults.standard.set("1", forKey: "grade")
                        }.tag(1)
                        Button("2학년") {
                            UserDefaults.standard.set("2", forKey: "grade")
                        }.tag(2)
                        Button("3학년") {
                            UserDefaults.standard.set("3", forKey: "grade")
                        }.tag(3)
                    }
                } else {
                    Text("학교를 등록해주세요.")
                }
            }
            .onChange(of: selectedGrade) { newValue in
                UserDefaults.standard.set(String(selectedGrade), forKey: "grade")
                print(selectedGrade)
                sendGetRequest(selectedGrade: selectedGrade)
            }.onAppear {
                if UserDefaults.standard.string(forKey: "class") == nil {
                    UserDefaults.standard.set("1", forKey: "grade")
                    UserDefaults.standard.set("1", forKey: "class")
                    selectedGrade = 1
                    selectedClass = 1
                }
                sendGetRequest(selectedGrade: selectedGrade)
                schoolName = (UserDefaults.standard.object(forKey: "schoolName") as? String)
            }
            Picker(selection: $selectedClass, label: Text("반 선택")) {
                if maxClass >= 1 {
                    ForEach(1...maxClass, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
            }.onChange(of: selectedClass) { newValue in
                UserDefaults.standard.set(String(selectedClass), forKey: "class")
                alertPresent.toggle()
            }.alert("학년과 반이 설정되었어요.", isPresented: $alertPresent) {
                Button("OK", role: .cancel){}
              }
        }
    }
    
    func sendGetRequest(selectedGrade:Int){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let officeCode:String? = (UserDefaults.standard.object(forKey: "officeCode") as? String)
        let schoolCode:String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
        
        let url = URL(string: "https://mealtimeapi.sungho-moon.workers.dev/hub/classInfo?ATPT_OFCDC_SC_CODE=\( officeCode ?? "")&SD_SCHUL_CODE=\(schoolCode ?? "")&AY=\(String(year))&GRADE=\(String(selectedGrade ))&type=json")!
        
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if let error = error {
                //에러
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            // 6. 데이터 처리
            let schoolJSON = JSON(data)
            maxClass = Int(schoolJSON["classInfo"][0]["head"][0]["list_total_count"].intValue)
        }
        // 7. 요청 실행
        task.resume()
    }
    
    struct GradeClassView_Previews: PreviewProvider {
        static var previews: some View {
            GradeClassView()
        }
    }
}
