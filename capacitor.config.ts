import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.twobeone',
  appName: 'TwoBeOne',
  webDir: 'dist',
  server: {
    url: 'https://www.twobeone.app/?app=1',
  },
  ios: {
    // DOM safe-area padding is applied explicitly. Native scroll insets leave
    // sticky/fixed controls visually shifted from their actual hit regions.
    contentInset: 'never',
    // Keep WKWebView from switching to a desktop layout or retaining an
    // accidental pinch-zoom level between interactions.
    preferredContentMode: 'mobile',
    zoomEnabled: false,
    scrollEnabled: true,
    allowsLinkPreview: false,
    backgroundColor: '#ffffff',
  },
};

export default config;
