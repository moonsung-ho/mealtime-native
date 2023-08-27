//
//  SchoolSettingsView.swift
//  mealtime
//
//  Created by 문성호 on 2023/04/09.
//

import SwiftUI
import SwiftyJSON
import AlertToast
import DebouncedOnChange

struct School: Hashable {
    let id = UUID()
    let name: String
    let address: String
    let schoolCode: String
    let officeCode: String
}

@available(iOS 16.0, *)
struct SchoolSettingsView: View {
    @State var schools:[School] = []
    @State var schoolCode: String = ""
    @State var storedSchoolCode:String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
    @State var officeCode: String = ""
    @State var storedOfficeCode:String? = (UserDefaults.standard.object(forKey: "officeCode") as? String)
    @State var searchString: String = ""
    @State var isNextPageActive = false
    @State var selectedSchool:String = "없음"
    @State var schoolFilter:String = ""
    @State var loading:Bool = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        if loading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle()) // 로딩 바 스타일 설정
                .scaleEffect(2) // 크기 조절
                .padding(.top, 20)
                .padding(.bottom, 20)
        }
        List(schools, id:\.self){ school in
            Group {
                HStack{
                    Button("\(school.name)\n\(Text(school.address).font(Font.footnote).foregroundColor(Color.gray))") {
                        selectedSchool = school.name
                        UserDefaults.standard.set(school.schoolCode, forKey: "schoolCode")
                        UserDefaults.standard.set(school.officeCode, forKey: "officeCode")
                        UserDefaults.standard.set(school.name, forKey: "schoolName")
                        MealView().sendGetRequest()
                    }.onChange(of: selectedSchool, perform: {(value) in
                        isNextPageActive = true
                    })
                }
            }
        }
        .listStyle(.inset)
        .searchable(
            text: $searchString,
            placement: .navigationBarDrawer,
            prompt: "급식중학교"
        )
        .toolbar{
            Picker(selection: $schoolFilter , label: Text("지역 필터")) {
                Group{
                    Text("모든 지역").tag("")
                    Text("서울").tag("서울특별시")
                    Text("경기").tag("경기도")
                    Text("부산").tag("부산광역시")
                    Text("대구").tag("대구광역시")
                    Text("인천").tag("인천광역시")
                    Text("광주").tag("광주광역시")
                    Text("대전").tag("대전광역시")
                    Text("울산").tag("울산광역시")
                    Text("세종").tag("세종특별자치시")
                }
                Text("충북").tag("충청북도")
                Text("충남").tag("충청남도")
                Text("전북").tag("전라북도")
                Text("전남").tag("전라남도")
                Text("경북").tag("경상북도")
                Text("경남").tag("경상남도")
                Text("강원").tag("강원특별자치도")
                Text("제주").tag("제주특별자치도")
            }
        }
        .onChange(of: schoolFilter){(value) in
            loading.toggle()
            sendGetRequest(stringToSearch: searchString, region: schoolFilter)
        }
        .onChange(of: searchString, debounceTime: .milliseconds(400)) { (value) in
            loading.toggle()
            sendGetRequest(stringToSearch: searchString, region: schoolFilter)
        }
        .sheet(isPresented: $isNextPageActive) {
            NavigationView {
                GradeClassView().navigationTitle(selectedSchool).toolbar{
                    Button("완료") {
                        isNextPageActive = false
                        presentation.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func sendGetRequest(stringToSearch: String, region: String) {
        schools = []
        // 1. URL 생성
    let url = URL(string: "https://open.neis.go.kr/hub/schoolInfo?Type=json&SCHUL_NM=\(stringToSearch.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&KEY=a9a5367947564a1aa13e46ba545de634&pSize=20&LCTN_SC_NM=\(region.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")!
    
    
        
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if error != nil {
                schools = [School(name: "에러가 발생했어요.", address: "문제가 지속될 경우 개발자에게 문의하세요.", schoolCode: "", officeCode: "")]
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                schools = [School(name: "인터넷 연결을 확인하세요.", address: "", schoolCode: "", officeCode: "")]
                return
            }
            
            guard let data = data else {
                schools = [School(name: "문제가 발생했어요.", address: "", schoolCode: "", officeCode: "")]
                return
            }

            // 6. 데이터 처리
            let schoolJSON = JSON(data)
            
            schools = []
            if (schoolJSON["schoolInfo"][1]["row"].rawString()) != nil {
                for i in 0..<schoolJSON["schoolInfo"][1]["row"].count {
                    schools.append(School(name:schoolJSON["schoolInfo"][1]["row"][i]["SCHUL_NM"].rawValue as! String, address:schoolJSON["schoolInfo"][1]["row"][i]["ORG_RDNMA"].rawValue as! String, schoolCode: schoolJSON["schoolInfo"][1]["row"][i]["SD_SCHUL_CODE"].rawValue as! String, officeCode: schoolJSON["schoolInfo"][1]["row"][i]["ATPT_OFCDC_SC_CODE"].rawValue as! String))
                }
            }
        }
        
        // 7. 요청 실행
        task.resume()
        loading.toggle()
    }
}



struct SchoolSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SchoolSettingsView()
    }
}
