import SwiftUI

struct NoticeView: View {
    var body: some View {
        List {
            VStack(alignment: .leading){
                Text("일부 학교의 급식이 보이지 않는 문제").font(.headline)
                Text("2023년 6월 25일").font(.caption)
            }.padding(2)
            Text("4세대 나이스 도입으로 인해 급식 식단을 각 학교에서 결재 후 데이터를 조회할 수 있게 되어 발생한 문제로 보여요. 학교 시스템에서 결재가 완료되면 조회할 수 있어요. 이 문제를 해결하기 위해 다방면으로 노력하고 있어요.").font(.body)
        }.navigationTitle("공지사항")
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
