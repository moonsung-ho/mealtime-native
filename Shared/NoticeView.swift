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
        List {
            VStack(alignment: .leading){
                Text(notices[0].head).font(.headline)
                Text("2023년 6월 25일").font(.caption)
            }.padding(2)
            Text("4세대 나이스 도입으로 인해 급식 식단을 각 학교에서 결재 후 데이터를 조회할 수 있게 되어 발생한 문제로 보여요. 학교 시스템에서 결재가 완료되면 조회할 수 있어요. 이 문제를 해결하기 위해 다방면으로 노력하고 있어요.").font(.body)
        }
        .navigationTitle("공지사항")
        .onAppear {
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
            for (notice) in noticeJSON {
                notices.append(Notice(head: noticeJSON["head"].rawValue as! String, body: noticeJSON["body"].rawValue as! String, date: noticeJSON["date"].rawValue as! String))
            }
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
