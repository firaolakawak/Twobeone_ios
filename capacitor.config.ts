import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.twobeone',
  appName: 'TwoBeOne',
  webDir: 'dist',
  server: {
    // Bump nativeBuild whenever an installed WebView must bypass an older app
    // shell while keeping the production app route unchanged.
    url: 'https://www.twobeone.app/?app=1&nativeBuild=20260823-1',
  },
  ios: {
    // DOM safe-area padding is applied explicitly. Native scroll insets leave
    // sticky/fixed controls visually shifted from their actual hit regions.
    contentInset: 'never',
    preferredContentMode: 'mobile',
    scrollEnabled: true,
    backgroundColor: '#ffffff',
  },
};

export default config;
