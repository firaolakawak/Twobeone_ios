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

# The Capacitor template declares its bridge controller in Main.storyboard.
# This app creates its WKWebView controller in SceneDelegate instead, so leaving
# those keys in place can initialize both controller paths during debugging.
if [[ -x /usr/libexec/PlistBuddy ]]; then
  /usr/libexec/PlistBuddy -c "Delete :UIMainStoryboardFile" "${info_plist}" 2>/dev/null || true
  /usr/libexec/PlistBuddy \
    -c "Delete :UIApplicationSceneManifest:UISceneConfigurations:UIWindowSceneSessionRoleApplication:0:UISceneStoryboardFile" \
    "${info_plist}" 2>/dev/null || true
fi

echo "Configured iOS to load the production web app in WKWebView."
