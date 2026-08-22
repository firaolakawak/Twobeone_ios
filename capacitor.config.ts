import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.example.app',
  appName: 'twobeone',
  webDir: 'www',
  server: {
    url: 'https://www.twobeone.app/',
    cleartext: true
  }
};

export default config;