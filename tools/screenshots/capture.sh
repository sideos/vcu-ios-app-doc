#!/usr/bin/env bash
# Regenerates assets/img/*.png: screenshots of the iOS wallet in the sideos
# branding, with made-up data, from the iOS Simulator.
#
#   tools/screenshots/capture.sh              # build, then capture everything
#   SKIP_BUILD=1 tools/screenshots/capture.sh # reuse the last build
#   ONLY=home,credentials tools/screenshots/capture.sh
#
# It never touches the app repository: it copies the source to $WORK, adds
# ScreenshotSeed.swift and patches a few lines in the copy (see `patch`).
#
# Environment: VCU_IOS_APP (app repo, default ../vcu-ios-app), BRAND (brand
# config, default Scripts/brand-sideos.json in the app repo), SIM_NAME
# (default "iPhone 18 Pro"), WORK (default ~/.cache/vcu-ios-app-doc).
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
DOC=$(cd "$HERE/../.." && pwd)
APP=$(cd "${VCU_IOS_APP:-$DOC/../vcu-ios-app}" && pwd)
WORK=${WORK:-$HOME/.cache/vcu-ios-app-doc}
BRAND=${BRAND:-$APP/Scripts/brand-sideos.json}
SIM_NAME=${SIM_NAME:-iPhone 18 Pro}
BUNDLE=com.etonec.vcuwallet
OUT=$DOC/assets/img
WIDTH=${WIDTH:-600}   # px; the site shows them at 300 CSS px

UDID=$(xcrun simctl list devices available | grep -F "$SIM_NAME (" | head -1 | grep -oE '[0-9A-F]{8}(-[0-9A-F]{4}){3}-[0-9A-F]{12}')
[ -n "$UDID" ] || { echo "no simulator named $SIM_NAME" >&2; exit 1; }

patch() {
  python3 -I - "$WORK/app" <<'PY'
import sys
root = sys.argv[1]
def edit(path, old, new):
    p = f"{root}/{path}"
    s = open(p).read()
    if old not in s:
        sys.exit(f"patch anchor not found in {path}: {old!r}. The app source changed; update capture.sh.")
    open(p, "w").write(s.replace(old, new, 1))
edit("VCuWallet/Wallet/WalletModel.swift",
     "    func reload() async {\n        guard let store else { return }\n",
     "    func reload() async {\n        guard let store else { return }\n        await ScreenshotSeed.prepare()\n        brand = Brand.current\n")
edit("VCuWallet/Wallet/WalletView.swift", "@State private var path: [Route] = []", "@State private var path: [Route] = ScreenshotSeed.routes")
edit("VCuWallet/Wallet/WalletView.swift", ".task { await model.reload() }", ".task { await model.reload(); ScreenshotSeed.apply(to: model) }")
# The simulator has no passcode, so the lock gate would unlock at once. -holdLock shows the lock screen and keeps it.
edit("VCuWallet/Wallet/AppLock.swift", "@State private var locked = WalletSettings.lockWhenOpening",
     '@State private var locked = WalletSettings.lockWhenOpening || ProcessInfo.processInfo.arguments.contains("-holdLock")')
edit("VCuWallet/Wallet/AppLock.swift", ".task { if locked { await authenticate() } }",
     '.task { if locked, !ProcessInfo.processInfo.arguments.contains("-holdLock") { await authenticate() } }')
# By-value requests carry transaction_data as a JSON array string; the app only reads it from signed requests.
edit("Packages/VCuCore/Sources/VCuCore/OpenID4VP/AuthorizationRequest.swift",
     'transactionData: params["transaction_data"] as? [String])',
     'transactionData: (params["transaction_data"] as? [String]) ?? (params["transaction_data"] as? String).flatMap { (try? JSONSerialization.jsonObject(with: Data($0.utf8))) as? [String] })')
PY
}

build() {
  mkdir -p "$WORK/app"
  rsync -a --delete --exclude .git --exclude build --exclude .build --exclude '*.xcodeproj' --exclude docs "$APP/" "$WORK/app/"
  cp "$HERE/ScreenshotSeed.swift" "$WORK/app/VCuWallet/Wallet/"
  patch
  (cd "$WORK/app" && xcodegen generate -q)
  xcodebuild -project "$WORK/app/VCuWallet.xcodeproj" -scheme VCuWallet -configuration Debug \
    -destination "platform=iOS Simulator,id=$UDID" -derivedDataPath "$WORK/dd" \
    CODE_SIGN_IDENTITY=- CODE_SIGNING_ALLOWED=YES CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= \
    -skipMacroValidation build > "$WORK/build.log" 2>&1 || { grep -E "error:" "$WORK/build.log" | sort -u | head -20; echo "build failed, see $WORK/build.log" >&2; exit 1; }
}

# A by-value, unsigned OpenID4VP request, as a verifier page would hand over.
vp_link() {  # vp_link <verifier host> <dcql json> [transaction_data json array]
  python3 -I - "$@" <<'PY'
import sys, urllib.parse as u
host, dcql = sys.argv[1], sys.argv[2]
uri = f"https://{host}/cb"
q = {"client_id": f"redirect_uri:{uri}", "response_uri": uri, "response_type": "vp_token", "response_mode": "direct_post",
     "nonce": "demo-nonce", "state": "demo-state", "dcql_query": dcql}
if len(sys.argv) > 3: q["transaction_data"] = sys.argv[3]
print("openid4vp://?" + u.urlencode(q, quote_via=u.quote))
PY
}

b64url_json() { python3 -I -c 'import sys,base64; print(base64.urlsafe_b64encode(sys.argv[1].encode()).decode().rstrip("="))' "$1"; }

MDL_DCQL='{"credentials":[{"id":"credential0","format":"mso_mdoc","meta":{"doctype_value":"org.iso.18013.5.1.mDL"},"claims":[{"path":["org.iso.18013.5.1","age_over_18"]}]}]}'
PAY_DCQL='{"credentials":[{"id":"credential0","format":"dc+sd-jwt","meta":{"vct_values":["urn:vcu:payment:1"]},"claims":[{"path":["iban"]}]}]}'
PAY_TX=$(b64url_json '{"type":"urn:eudi:sca:payment:1","credential_ids":["credential0"],"payload":{"payee":{"name":"Café Aurora"},"amount":"12.80","currency":"EUR"}}')

# shot <name> <light|dark> [launch args...]   (env LINK: a link to open; DEFAULT_BRAND=0 for etonec)
shot() {
  local name=$1 mode=$2; shift 2
  if [ -n "${ONLY:-}" ] && [[ ",$ONLY," != *",$name,"* ]]; then return; fi
  xcrun simctl ui "$UDID" appearance "$mode"
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  local args=(-seedDemo -AppleLanguages "(en)" -AppleLocale en_US)
  if [ "${DEFAULT_BRAND:-}" = 1 ]; then args+=(-noBrand); else args+=(-brandFile "$WORK/brand.json"); fi
  [ -n "${LINK:-}" ] && args+=(-open "$LINK")
  xcrun simctl launch "$UDID" "$BUNDLE" "${args[@]}" "$@" >/dev/null
  sleep "${WAIT:-4}"
  xcrun simctl io "$UDID" screenshot "$WORK/raw.png" >/dev/null 2>&1
  magick "$WORK/raw.png" -resize "${WIDTH}x" -strip "$OUT/$name.png"
  echo "  $name"
}

[ "${SKIP_BUILD:-}" = 1 ] || build
mkdir -p "$OUT"
cp "$BRAND" "$WORK/brand.json"

xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl bootstatus "$UDID" -b >/dev/null
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged --batteryLevel 100 \
  --cellularMode active --cellularBars 4 --wifiBars 3 --operatorName ""
xcrun simctl uninstall "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl install "$UDID" "$WORK/dd/Build/Products/Debug-iphonesimulator/VCuWallet.app"
# First launch seeds the demo data; do it once up front so no shot races it.
xcrun simctl launch "$UDID" "$BUNDLE" -seedDemo -brandFile "$WORK/brand.json" >/dev/null
sleep 6
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
echo "Capturing into $OUT"

shot home light
shot home-dark dark
DEFAULT_BRAND=1 shot home-default light
shot credentials light -route credentials
shot credentials-dark dark -route credentials
shot credential-detail light -route credentials,detail
shot credential-expiring light -route credentials,detail-pid
shot offer-consent light -show offer
shot tx-code light -show txcode
shot issuer-choice light -show choice
shot outcome-added light -show added
LINK=$(vp_link shop.example.com "$MDL_DCQL") shot share-consent light
LINK=$(vp_link shop.example.com "$MDL_DCQL") shot share-consent-dark dark
LINK=$(vp_link pay.example.org "$PAY_DCQL" "[\"$PAY_TX\"]") shot payment-consent light
shot outcome-shared light -show shared
shot outcome-paid light -show paid
shot outcome-offline light -show offline
shot activity light -route activity
shot activity-event light -route activity,event
shot notifications light -route notifications
shot paste light -route paste
shot settings light -route settings
shot privacy light -route settings,privacy
shot security light -route settings,security
shot requesters light -route settings,requesters
shot branding light -route settings,branding
shot branding-default light -route settings,branding -noBrand
shot tags light -route settings,tags
WAIT=3 shot lock light -holdLock

xcrun simctl status_bar "$UDID" clear
xcrun simctl ui "$UDID" appearance light
echo "Done: $(ls "$OUT" | wc -l | tr -d ' ') images in $OUT"
