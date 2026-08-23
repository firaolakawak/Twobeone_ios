import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.twobeone',
  appName: 'TwoBeOne',
  webDir: 'dist',
  ios: {
    // Keep the entire web document inside the status-bar and home-indicator
    // safe area. Web/PWA builds continue to use CSS env() insets instead.
    contentInset: 'always',
  },
};

export default config;
