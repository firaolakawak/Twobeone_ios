#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_directory="$(cd -- "${script_directory}/.." && pwd)"
source_file="${project_directory}/native/ios/SceneDelegate.swift"
destination_file="${project_directory}/ios/App/App/SceneDelegate.swift"
info_plist="${project_directory}/ios/App/App/Info.plist"
scheme_source="${project_directory}/native/ios/App.xcscheme"
scheme_directory="${project_directory}/ios/App/App.xcodeproj/xcshareddata/xcschemes"

if [[ ! -f "${destination_file}" ]]; then
  echo "Missing generated iOS project. Run 'npx cap add ios' first." >&2
  exit 1
fi

cp "${source_file}" "${destination_file}"
mkdir -p "${scheme_directory}"
cp "${scheme_source}" "${scheme_directory}/App.xcscheme"

# Restore the standard Capacitor storyboard declarations if an older setup
# script removed them. CAPBridgeViewController depends on the normal template
# lifecycle and remains the sole WebView host.
if [[ -x /usr/libexec/PlistBuddy ]]; then
  /usr/libexec/PlistBuddy -c "Print :UIMainStoryboardFile" "${info_plist}" >/dev/null 2>&1 || \
    /usr/libexec/PlistBuddy -c "Add :UIMainStoryboardFile string Main" "${info_plist}"
  /usr/libexec/PlistBuddy \
    -c "Print :UIApplicationSceneManifest:UISceneConfigurations:UIWindowSceneSessionRoleApplication:0:UISceneStoryboardFile" \
    "${info_plist}" >/dev/null 2>&1 || \
    /usr/libexec/PlistBuddy \
      -c "Add :UIApplicationSceneManifest:UISceneConfigurations:UIWindowSceneSessionRoleApplication:0:UISceneStoryboardFile string Main" \
      "${info_plist}"
fi

echo "Configured iOS to load the production web app in WKWebView."
