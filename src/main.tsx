import { createRoot } from "react-dom/client";
import { Capacitor } from "@capacitor/core";
import App from "./app/App.tsx";
import "./index.css";

document.documentElement.classList.toggle("capacitor-native", Capacitor.isNativePlatform());

createRoot(document.getElementById("root")!).render(<App />);
