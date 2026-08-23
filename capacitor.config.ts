import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'app.twobeone',
  appName: 'TwoBeOne',
  webDir: 'dist',
  ios: {
    // DOM safe-area padding is applied explicitly. Native scroll insets leave
    // sticky/fixed controls visually shifted from their actual hit regions.
    contentInset: 'never',
  },
};

export default config;
