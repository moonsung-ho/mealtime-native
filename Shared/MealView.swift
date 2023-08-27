import SwiftUI
import SwiftyJSON
import Foundation
import AppTrackingTransparency

struct MealView: View {
    @State var meals: [String] = []
    @State var meal: String = ""
    @State private var selectedDate = Date()
    @State var loading: Bool = false
    @State var schoolName:String = ""
    @State var fancyDate: String = ""
    @AppStorage("after7Display") var after7Display: Bool = false
    @AppStorage("needToDisplaySchoolSettingsModal") var needToDisplaySchoolSettingsModal: Bool = false
    //    @State var needToDisplaySchoolSettingsModal: Bool = false
    
    var body: some View {
        NavigationView {
            VStack{
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
                List(meals, id: \.self) { meal in
                    if meal.contains("!"){Text(meal.filter { !"!".contains($0) }).foregroundColor(Color.red)}
                    else {
                        Text(meal)
                    }
                }
                .onAppear {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    dateFormatter.dateStyle = .long
                    dateFormatter.locale = Locale(identifier: "ko_kr")
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
                }
                        .listStyle(.inset)
                        .refreshable {
                            sendGetRequest()
                        }
                        .sheet(isPresented: $needToDisplaySchoolSettingsModal) {
                            NavigationView {
                                SchoolSettingsView()
                                    .toolbar {
                                        ToolbarItem(placement: .navigationBarLeading) {
                                            VStack(alignment: .leading) {
                                                Text("학교 설정하기").font(.title2).bold()
                                                Text("다니는 학교를 검색하고 선택해 주세요.").font(Font.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                                            }
                                        }
                                    }
                            }.padding(.top, 10).interactiveDismissDisabled(true)
                                .onDisappear {
                                    sendGetRequest()
                                    needToDisplaySchoolSettingsModal = false
                                }
                        }.interactiveDismissDisabled(true)
                    AdBannerView()
                }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                        if status == .authorized {
                        }
                        else {
                        }
                    })
                }.navigationBarTitle("급식")
                .toolbar {
                    ShareLink(item: "\(fancyDate)의 \(schoolName) 급식: \(meals.joined(separator: ", "))") {
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
            let schoolCode: String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
            let officeCode: String? = UserDefaults.standard.object(forKey: "officeCode") as? String
            let allergy: String? = UserDefaults.standard.object(forKey: "allergy") as? String
            schoolName = UserDefaults.standard.object(forKey: "schoolName") as? String ?? ""
            // 1. URL 생성
            let url = URL(string: "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&pIndex=1&pSize=100&ATPT_OFCDC_SC_CODE=\(officeCode ?? "")&SD_SCHUL_CODE=\(schoolCode ?? "")&MLSV_YMD=\(formattedDate)&KEY=a9a5367947564a1aa13e46ba545de634&MMEAL_SC_CODE=2")!
            
            // 2. URL Request 생성
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // 3. URLSession 생성
            let session = URLSession.shared
            
            // 4. URLSessionDataTask 생성
            let task = session.dataTask(with: request) { data, response, error in
                // 5. 응답 처리
                if error != nil {
                    meals = ["인터넷 연결을 확인해 보세요."]
                    HapticManager.instance.notification(type: .error)
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    meals = ["인터넷 연결을 확인해 보세요."]
                    return
                }
                
                guard let data = data else {
                    meals = ["문제가 발생했어요. 앱을 재실행해 보세요."]
                    return
                }
                
                // 6. 데이터 처리
                let mealJSON = JSON(data)
                guard let meal = mealJSON["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"].rawValue as? String else {
                    if schoolCode == nil {
                        meals = ["학교를 등록하면 급식을 볼 수 있어요."]
                    } else {
                        meals = ["급식이 등록되지 않았어요."]
                    }
                    return
                }
                //meal = meal.filter { !"0123456789. ".contains($0) }
                //meal = meal.filter { !"()".contains($0) }
                meals = meal.components(separatedBy: "<br/>")
                for (index, meal) in meals.enumerated() {
                    if meal.split(separator: " ").count == 2 {
                        let separatedMeal = meal.split(separator: " ")[1].filter { !"()".contains($0) }
                        let spmeal = separatedMeal.split(separator: ".")
                        let allergyAlert = (allergy ?? "")
                        meals[index] = meal.filter { !"0123456789.()".contains($0) }
                        for allergies in spmeal{
                            if allergies == allergyAlert{
                                meals[index] = "!\(meals[index])"
                            }
                        }
                    }
                }
            }
            // 7. 요청 실행
            task.resume()
            loading.toggle()
        }
    }
    
    struct MealResponse: Codable {
        let meals: String
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            MealView()
        }
    }
