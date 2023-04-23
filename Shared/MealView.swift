import SwiftUI
import SwiftyJSON
import Foundation
import AppTrackingTransparency

struct MealView: View {
    @State var meals: [String] = []
    @State var meal: String = ""
    @State private var selectedDate = Date()
    
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
                List(meals, id: \.self) { meal in
                    if meal.contains("!"){Text(meal.filter { !"!".contains($0) }).foregroundColor(Color.red)}
                    else {
                        Text(meal)
                    }
                    
                }.onAppear {
                    sendGetRequest()
                }.listStyle(.inset)
                AdBannerView()
            }.onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    if status == .authorized {
                        //print("인증됨")
                    }
                    else {
                        //print("노노")
                    }
                })
            }.navigationBarTitle("급식")
        }
    }
    
    var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            return dateFormatter.string(from: selectedDate)
        }
    
    func sendGetRequest() {
        meals = ["로딩중이에요."]
        let schoolCode: String? = (UserDefaults.standard.object(forKey: "schoolCode") as? String)
        let officeCode: String? = UserDefaults.standard.object(forKey: "officeCode") as? String
        let allergy: String? = UserDefaults.standard.object(forKey: "allergy") as? String
        // 1. URL 생성
        let url = URL(string: "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&pIndex=1&pSize=100&ATPT_OFCDC_SC_CODE=\(officeCode ?? "")&SD_SCHUL_CODE=\(schoolCode ?? "")&MLSV_YMD=\(formattedDate)")!
        
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if error != nil {
                meals = ["에러가 발생했어요. 지속될 경우 개발자에게 문의하세요."]
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                meals = ["인터넷 연결을 확인하세요."]
                return
            }
            
            guard let data = data else {
                meals = ["문제가 발생했어요. 앱을 재실행해 주세요."]
                return
            }

            // 6. 데이터 처리
            let mealJSON = JSON(data)
            guard let meal = mealJSON["mealServiceDietInfo"][1]["row"][0]["DDISH_NM"].rawValue as? String else {
                if schoolCode == nil {
                    meals = ["학교를 등록해주세요."]
                } else{
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
