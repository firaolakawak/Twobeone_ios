import { defineConfig } from 'vite'
import path from 'path'
import tailwindcss from '@tailwindcss/vite'
import react from '@vitejs/plugin-react'


function figmaAssetResolver() {
  return {
    name: 'figma-asset-resolver',
    resolveId(id) {
      if (id.startsWith('figma:asset/')) {
        const filename = id.replace('figma:asset/', '')
        return path.resolve(__dirname, 'src/assets', filename)
      }
    },
  }
}

// Figma Make exports some imports with their original package version appended
// (for example, "sonner@2.0.3"). Resolve those imports to the package installed
// and pinned in package.json so standard Vite builds work outside Figma Make.
function versionedPackageResolver() {
  return {
    name: 'versioned-package-resolver',
    async resolveId(id, importer) {
      const match = id.match(/^((?:@[^/]+\/)?[^@/]+)@\d+(?:\.\d+){0,2}(?:-[^/]+)?$/)

      if (!match) return null

      return this.resolve(match[1], importer, { skipSelf: true })
    },
  }
}

export default defineConfig({
  plugins: [
    figmaAssetResolver(),
    versionedPackageResolver(),
    // The React and Tailwind plugins are both required for Make, even if
    // Tailwind is not being actively used – do not remove them
    react(),
    tailwindcss(),
  ],
  // Serve static assets (service-worker.js, manifest.json, offline.html, icons)
  // from src/app/public/ at the root path so /service-worker.js resolves correctly
  publicDir: 'src/app/public',
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src/app'),
    },
  },
})
