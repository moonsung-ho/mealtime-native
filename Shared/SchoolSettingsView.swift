//
//  SchoolSettingsView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/09.
//

import SwiftUI
import SwiftyJSON

struct School: Hashable {
    let id = UUID()
    let name: String
    let address: String
    let schoolCode: String
    let officeCode: String
}

struct SchoolSettingsView: View {
    @State var schools:[School] = []
    @State var schoolCode: String = ""
    @State var storedSchoolCode:String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
    @State var officeCode: String = ""
    @State var storedOfficeCode:String? = (UserDefaults.standard.object(forKey: "officeCode") as? String)
    @State var alertIsPresented: Bool = false
    @State var searchString: String = ""
    @State var isNextPageActive = false
    
    var body: some View {
        //        TextField("학교 코드", text: $schoolCode)
        //        TextField("교육청 코드", text: $officeCode)
        //        Text(storedSchoolCode ?? "미정")
        //        Text(storedOfficeCode ?? "미정")
        //        Button("확인") {
        //            UserDefaults.standard.set(schoolCode, forKey: "schoolCode")
        //            storedSchoolCode = schoolCode
        //            UserDefaults.standard.set(officeCode, forKey: "officeCode")
        //            storedOfficeCode = officeCode
        //        }
        TextField("학교 검색", text: $searchString)
        Text(searchString)
        Button("검색") {
            sendGetRequest(stringToSearch: searchString)
        }
        List(schools, id:\.self){ school in
            HStack{
                Button("\(school.name)\n\(school.address)") {
                    UserDefaults.standard.set(school.schoolCode, forKey: "schoolCode")
                    UserDefaults.standard.set(school.officeCode, forKey: "officeCode")
                    UserDefaults.standard.set(school.name, forKey: "schoolName")
                    alertIsPresented.toggle()
                    print(UserDefaults.standard.object(forKey: "schoolCode") as? String ?? "없음")
                    self.isNextPageActive = true
                }
                NavigationLink(destination: GradeClassView(), isActive: $isNextPageActive) {
                    EmptyView()
                }
            }
        }
    .listStyle(.inset)
}
    
    
func sendGetRequest(stringToSearch: String) {
        schools = [School(name: "로딩중이에요.", address: "", schoolCode: "", officeCode: "")]
        // 1. URL 생성
    print(stringToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    let url = URL(string: "https://open.neis.go.kr/hub/schoolInfo?Type=json&pIndex=1&pSize=10000&SCHUL_NM=\(stringToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
    
    
        
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }

            // 6. 데이터 처리
            let schoolJSON = JSON(data)
            schools.remove(at: 0)
            if (schoolJSON["schoolInfo"][1]["row"].rawString()) != nil {
                for i in 0..<schoolJSON["schoolInfo"][1]["row"].count {
                    schools.append(School(name:schoolJSON["schoolInfo"][1]["row"][i]["SCHUL_NM"].rawValue as! String, address:schoolJSON["schoolInfo"][1]["row"][i]["ORG_RDNMA"].rawValue as! String, schoolCode: schoolJSON["schoolInfo"][1]["row"][i]["SD_SCHUL_CODE"].rawValue as! String, officeCode: schoolJSON["schoolInfo"][1]["row"][i]["ATPT_OFCDC_SC_CODE"].rawValue as! String))
                }
            }
        }
        
        // 7. 요청 실행
        task.resume()
    }
}



struct SchoolSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolSettingsView()
    }
}
