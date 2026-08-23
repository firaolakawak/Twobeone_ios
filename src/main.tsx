import { createRoot } from "react-dom/client";
import { Capacitor } from "@capacitor/core";
import App from "./app/App.tsx";
import "./index.css";

const capacitorPlatform = Capacitor.getPlatform();
document.documentElement.classList.toggle("capacitor-native", capacitorPlatform !== "web");
document.documentElement.classList.toggle("capacitor-ios", capacitorPlatform === "ios");

createRoot(document.getElementById("root")!).render(<App />);
