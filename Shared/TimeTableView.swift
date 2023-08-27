import SwiftUI
import SwiftyJSON

struct TimeTableView: View {
    @State var timeTable: [String] = []
    @State private var selectedDate = Date()
    @State var schoolForm = "els"
    @State var loading: Bool = false
    @State var classN: String? = ""
    @State var grade: String? = ""
    @State var fancyDate: String = ""
    @State var schoolName: String? = ""
    @AppStorage("after7Display") var after7Display: Bool = false
    
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
                    ).environment(\.locale, Locale.init(identifier: "ko"))
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .onChange(of: selectedDate, perform: { (value) in
                        sendGetRequest()
                        HapticManager.instance.selectionChanged()
                    }).padding(10)
                    Button("\(Image(systemName: "chevron.forward"))"){
                        selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate)!
                    }.buttonStyle(.bordered)
                }
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle()) // 로딩 바 스타일 설정
                        .scaleEffect(2) // 크기 조절
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                }
                List(timeTable, id: \.self) { lesson in
                    if lesson.contains("!"){Text(lesson.filter { !"!".contains($0) }).foregroundColor(Color.red)}
                    else {
                        Text(lesson)
                    }
                    
                }.onAppear {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    let calendar = Calendar.current
                    let hour = calendar.component(.hour, from: Date())
                    if after7Display == true {
                        if hour >= 20 {
                            if dateFormatter.string(from: selectedDate) == dateFormatter.string(from: Date() ) {
                                selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                            }
                        }
                    }
                    sendGetRequest()
                }.listStyle(.inset).refreshable {
                    sendGetRequest()
                }
                AdBannerView()
            }.navigationBarTitle("시간표")
                .toolbar {
                    ShareLink(item: "\(fancyDate)의 \(schoolName ?? "") \(grade ?? "알 수 없는")학년 \(classN ?? "알 수 없는")반 시간표: \(timeTable.joined(separator: ", "))") {
                        Image(systemName: "square.and.arrow.up")
                    }.onAppear {
                        let Formatter = DateFormatter()
                        Formatter.dateFormat = "M월 d일"
                        fancyDate = Formatter.string(from: selectedDate)
                    }.simultaneousGesture(TapGesture().onEnded() {
                        HapticManager.instance.impact(style: .medium)
                    })
                }
        }
    }
    
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: selectedDate)
        }
    
    func sendGetRequest() {
        loading.toggle()
        timeTable = []
        let schoolCode: String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
        let officeCode: String? = UserDefaults.standard.object(forKey: "officeCode") as? String
        classN = UserDefaults.standard.object(forKey: "class") as? String
        grade = UserDefaults.standard.object(forKey: "grade") as? String
        schoolName = UserDefaults.standard.object(forKey: "schoolName") as? String
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
        let url = URL(string: "https://open.neis.go.kr/hub/\(schoolForm)Timetable?type=json&ATPT_OFCDC_SC_CODE=\(officeCode ?? "")&SD_SCHUL_CODE=\(schoolCode ?? "")&ALL_TI_YMD=\(formattedDate)&GRADE=\(grade ?? "")&CLASS_NM=\(classN ?? "")&KEY=a9a5367947564a1aa13e46ba545de634")!
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if error != nil {
                timeTable = ["인터넷 연결을 확인해 보세요."]
                HapticManager.instance.notification(type: .error)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                timeTable = ["인터넷 연결을 확인해 보세요."]
                return
            }
            
            guard let data = data else {
                timeTable = ["문제가 발생했어요. 앱을 재실행해 보세요."]
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
            for (_, lesson) in timeTableJSON["\(schoolForm)Timetable"][1]["row"].enumerated() {
                timeTable.append("\(lesson.1["PERIO"].rawValue as! String): \(lesson.1["ITRT_CNTNT"].rawValue as! String)")
            }
            if timeTable.count == 0 {
                if schoolCode == nil{
                    timeTable.append("학교와 반을 등록하면 시간표를 볼 수 있어요.")
                } else if grade == nil {
                    timeTable.append("학년/반을 등록하면 시간표를 볼 수 있어요.")
                } else {
                    timeTable.append("시간표가 등록되지 않았어요.")
                }
            }
        }
        
        // 7. 요청 실행
        task.resume()
        loading.toggle()
    }
}

