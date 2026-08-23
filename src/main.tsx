import { createRoot } from "react-dom/client";
import { Capacitor } from "@capacitor/core";
import App from "./app/App.tsx";
import "./index.css";

const capacitorPlatform = Capacitor.getPlatform();
const appParameter = new URLSearchParams(window.location.search).get("app");
let rememberedAppShell = false;

try {
  if (appParameter === "1") {
    window.localStorage.setItem("twobeone_app_shell", "1");
  } else if (appParameter === "0") {
    window.localStorage.removeItem("twobeone_app_shell");
  }
  rememberedAppShell = window.localStorage.getItem("twobeone_app_shell") === "1";
} catch {
  // The URL and Capacitor bridge remain sufficient when storage is disabled.
}

const appShellRequested = appParameter === "1" || (appParameter !== "0" && rememberedAppShell);
const isIPadOS = navigator.platform === "MacIntel" && navigator.maxTouchPoints > 1;
const isIOSDevice = /iPad|iPhone|iPod/.test(navigator.userAgent) || isIPadOS;
const isNativeApp = capacitorPlatform !== "web" || appShellRequested;
const isIOSApp = capacitorPlatform === "ios" || (appShellRequested && isIOSDevice);

document.documentElement.classList.toggle("capacitor-native", isNativeApp);
document.documentElement.classList.toggle("capacitor-ios", isIOSApp);

// A standalone app should behave like a native screen, not a zoomable browser
// page. Apply this only to the app shell so the public website stays accessible.
if (isNativeApp) {
  const viewport = document.querySelector<HTMLMetaElement>('meta[name="viewport"]');
  viewport?.setAttribute(
    "content",
    "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover",
  );
}

createRoot(document.getElementById("root")!).render(<App />);
