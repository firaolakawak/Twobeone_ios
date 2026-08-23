import UIKit
import WebKit

private let appURL = URL(string: "https://www.twobeone.app/?app=1")!

/// A deliberately thin native container for the production web application.
/// The page owns its viewport and safe-area layout exactly as it does in Safari.
final class AppWebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private var webView: WKWebView!

    override func loadView() {
        let rootView = UIView()
        rootView.backgroundColor = .white

        let configuration = WKWebViewConfiguration()
        configuration.websiteDataStore = .default()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true

        if #available(iOS 13.0, *) {
            configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        }

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.scrollView.keyboardDismissMode = .interactive
        webView.isOpaque = true
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white

        rootView.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: rootView.topAnchor),
            webView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: rootView.bottomAnchor),
        ])

        self.webView = webView
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        clearStaleWebAppDataAndLoad(appURL)
    }

    func load(_ url: URL) {
        loadViewIfNeeded()
        loadFromNetwork(url)
    }

    private func clearStaleWebAppDataAndLoad(_ url: URL) {
        // Keep authentication, local storage, and user preferences. Only remove
        // resources that can combine an old service-worker shell with new CSS.
        let cacheTypes: Set<String> = [
            WKWebsiteDataTypeDiskCache,
            WKWebsiteDataTypeMemoryCache,
            WKWebsiteDataTypeOfflineWebApplicationCache,
            "WKWebsiteDataTypeServiceWorkerRegistrations",
        ]

        webView.configuration.websiteDataStore.removeData(
            ofTypes: cacheTypes,
            modifiedSince: .distantPast
        ) { [weak self] in
            DispatchQueue.main.async {
                self?.loadFromNetwork(url)
            }
        }
    }

    private func loadFromNetwork(_ url: URL) {
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: 30
        )
        webView.load(request)
    }

    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        loadFromNetwork(webView.url ?? appURL)
    }

    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if navigationAction.targetFrame == nil, let url = navigationAction.request.url {
            webView.load(URLRequest(url: url))
        }
        return nil
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .white
        window.rootViewController = AppWebViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        webViewController?.load(url)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let url = userActivity.webpageURL else { return }
        webViewController?.load(url)
    }

    private var webViewController: AppWebViewController? {
        window?.rootViewController as? AppWebViewController
    }
}
