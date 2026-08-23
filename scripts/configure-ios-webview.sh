#!/usr/bin/env bash
set -euo pipefail

script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
project_directory="$(cd -- "${script_directory}/.." && pwd)"
source_file="${project_directory}/native/ios/SceneDelegate.swift"
destination_file="${project_directory}/ios/App/App/SceneDelegate.swift"

if [[ ! -f "${destination_file}" ]]; then
  echo "Missing generated iOS project. Run 'npx cap add ios' first." >&2
  exit 1
fi

cp "${source_file}" "${destination_file}"
echo "Configured iOS to load the production web app in WKWebView."
