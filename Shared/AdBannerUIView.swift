import SwiftUI
import GoogleMobileAds

struct AdBannerUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
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
            .background(Color.white)
    }
}
