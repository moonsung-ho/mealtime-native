import SwiftUI
import GoogleMobileAds

struct AdBannerUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-7245930610023842/4484950317"
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.load(GADRequest())
        return bannerView
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) { }
}

struct AdBannerView: View {
    var body: some View {
        AdBannerUIView()
            .frame(height: 50)
            .foregroundColor(Color(UIColor.systemBackground))
    }
}
