import UIKit
import Capacitor
import WebKit

/// Standard Capacitor WebView host. The production URL is supplied exclusively
/// by capacitor.config.ts, so the native layer does not alter the remote page.
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var didInstallBridge = false

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        let loadingController = UIViewController()
        loadingController.view.backgroundColor = .white
        window.rootViewController = loadingController
        self.window = window
        window.makeKeyAndVisible()

        SceneDelegateProxy.shared.scene(
            scene,
            willConnectTo: session,
            options: connectionOptions
        )

        clearWebCachesAndInstallBridge()
    }

    private func clearWebCachesAndInstallBridge() {
        URLCache.shared.removeAllCachedResponses()

        let availableTypes = WKWebsiteDataStore.allWebsiteDataTypes()
        let cacheTypes = availableTypes.filter { type in
            let normalizedType = type.lowercased()
            return normalizedType.contains("cache") || normalizedType.contains("serviceworker")
        }

        let fallback = DispatchWorkItem { [weak self] in
            self?.installBridgeIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: fallback)

        WKWebsiteDataStore.default().removeData(
            ofTypes: cacheTypes,
            modifiedSince: .distantPast
        ) { [weak self] in
            DispatchQueue.main.async {
                fallback.cancel()
                self?.installBridgeIfNeeded()
            }
        }
    }

    private func installBridgeIfNeeded() {
        guard !didInstallBridge else { return }
        didInstallBridge = true
        window?.rootViewController = CAPBridgeViewController()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        SceneDelegateProxy.shared.scene(scene, openURLContexts: URLContexts)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        SceneDelegateProxy.shared.scene(scene, continue: userActivity)
    }
}
