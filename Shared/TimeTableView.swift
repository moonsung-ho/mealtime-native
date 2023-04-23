import SwiftUI
import SwiftyJSON

struct TimeTableView: View {
    @State var timeTable: [String] = []
    @State private var selectedDate = Date()
    @State var schoolForm = "els"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button("\(Image(systemName: "chevron.backward"))"){
                        selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
                    }.buttonStyle(.bordered)
                    DatePicker(
                        "날짜 선택",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .onChange(of: selectedDate, perform: { (value) in
                        sendGetRequest()
                    }).padding(10)
                    Button("\(Image(systemName: "chevron.forward"))"){
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    }.buttonStyle(.bordered)
                }
                List(timeTable, id: \.self) { meal in
                    if meal.contains("!"){Text(meal.filter { !"!".contains($0) }).foregroundColor(Color.red)}
                    else {
                        Text(meal)
                    }
                    
                }.onAppear {
                    sendGetRequest()
                }.listStyle(.inset)
                AdBannerView()
            }.navigationBarTitle("시간표")
        }
    }
    
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: selectedDate)
        }
    
    func sendGetRequest() {
        timeTable = ["로딩중이에요."]
        let schoolCode: String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
        let officeCode: String? = UserDefaults.standard.object(forKey: "officeCode") as? String
        let classN: String? = UserDefaults.standard.object(forKey: "class") as? String
        let grade: String? = UserDefaults.standard.object(forKey: "grade") as? String
        if schoolCode != nil {
            if ((UserDefaults.standard.object(forKey: "schoolName") as? String)!.contains("초등학교")) {
                schoolForm = "els"
            }
            else if ((UserDefaults.standard.object(forKey: "schoolName") as? String)!.contains("중학교")) {
                schoolForm = "mis"
            }
            else if ((UserDefaults.standard.object(forKey: "schoolName") as? String)!.contains("고등학교")) {
                schoolForm = "his"
            }
        }
        
        // 1. URL 생성
        let url = URL(string: "https://open.neis.go.kr/hub/\(schoolForm)Timetable?type=json&ATPT_OFCDC_SC_CODE=\(officeCode ?? "")&SD_SCHUL_CODE=\(schoolCode ?? "")&ALL_TI_YMD=\(formattedDate)&GRADE=\(grade ?? "")&CLASS_NM=\(classN ?? "")")!
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if error != nil {
                timeTable = ["에러가 발생했어요. 문제가 지속될 경우 개발자에게 문의하세요."]
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                timeTable = ["인터넷 연결을 확인하세요."]
                return
            }
            
            guard let data = data else {
                timeTable = ["문제가 발생했어요."]
                return
            }

            // 6. 데이터 처리
            let timeTableJSON = JSON(data)
//            guard var time = timeTableJSON["misTimetable"][1]["row"][0]["DDISH_NM"].rawValue as? String else {
//                if schoolCode == nil {
//                    timeTable = ["학교를 등록해주세요."]
//                } else{
//                    timeTable = ["급식이 등록되지 않았어요."]
//                }
//                return
//            }
            //meal = meal.filter { !"0123456789. ".contains($0) }
            //meal = meal.filter { !"()".contains($0) }
            timeTable.remove(at: 0)
            
            for (_, lesson) in timeTableJSON["\(schoolForm)Timetable"][1]["row"].enumerated() {
                timeTable.append("\(lesson.1["PERIO"].rawValue as! String): \(lesson.1["ITRT_CNTNT"].rawValue as! String)")
            }
            if timeTable.count == 0 {
                if schoolCode == nil{
                    timeTable.append("학교를 등록해주세요.")
                } else if grade == nil {
                    timeTable.append("학년/반을 등록해주세요.")
                } else {
                    timeTable.append("시간표가 등록되지 않았어요.")
                }
            }
        }
        
        // 7. 요청 실행
        task.resume()
    }
}

