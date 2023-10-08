import SwiftUI
import SwiftyJSON

struct Notice: Hashable {
    let id = UUID()
    let head: String
    let body: String
    let date: String
}

struct NoticeView: View {
    @State var notices:[Notice] = [Notice(head: "불러오는 중이에요.", body: "", date: "")]
    var body: some View {
        List (notices, id: \.self) { notice in
            Section {
                VStack(alignment: .leading){
                    Text(notice.head).fontWeight(.semibold)
                }
                Text(notice.body).font(.body)
            } header: {
                Text(notice.date)
            }
        }
        .navigationTitle("공지사항")
        .onAppear {
            sendGetRequest()
        }
        .refreshable {
            sendGetRequest()
        }
    }
    
    func sendGetRequest() {
        // 1. URL 생성
        let url = URL(string: "https://raw.githubusercontent.com/moonsung-ho/mealtime-native/master/Shared/notice.json")!
        
        // 2. URL Request 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // 3. URLSession 생성
        let session = URLSession.shared
        
        // 4. URLSessionDataTask 생성
        let task = session.dataTask(with: request) { data, response, error in
            // 5. 응답 처리
            if error != nil {
                HapticManager.instance.notification(type: .error)
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
            let noticeJSON = JSON(data)
            notices.removeAll()
            print(noticeJSON)
            for i in 0..<noticeJSON.count {
                notices.append(Notice(head: noticeJSON[i]["head"].rawValue as! String, body: noticeJSON[i]["body"].rawValue as! String, date: noticeJSON[i]["date"].rawValue as! String))
            }
//            notices.append(Notice(head: noticeJSON[0]["head"].rawValue as! String, body: noticeJSON[0]["body"].rawValue as! String, date: noticeJSON[0]["date"].rawValue as! String))
            print(notices)
            return
        }
        // 7. 요청 실행
        task.resume()
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
