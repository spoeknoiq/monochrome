#!/bin/sh
set -eu

HARNESS_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HARNESS_DIR/../.." && pwd)
SRC="$ROOT/tweak/Sources"
OUT="$HARNESS_DIR/build"
APP="$OUT/ArtistHarness.app"
IPA="$OUT/ArtistHarness.ipa"
THEOS=${THEOS:-$HOME/theos}

[ -x "$THEOS/bin/logos.pl" ] || { echo "logos.pl not found; set THEOS (currently: $THEOS)" >&2; exit 1; }
command -v xcrun >/dev/null 2>&1 || { echo "xcrun not found; install/select Xcode" >&2; exit 1; }
command -v zip >/dev/null 2>&1 || { echo "zip not found" >&2; exit 1; }

rm -rf "$OUT"
mkdir -p "$OUT/gen" "$APP" "$OUT/Payload"

for f in Redesigned/Artist/ArtistField.x Redesigned/Artist/ArtistHeader.x Redesigned/Artist/ArtistSections.x Redesigned/Artist/ArtistFollow.x; do
    name=$(basename "$f" .x)
    "$THEOS/bin/logos.pl" -c generator=internal "$SRC/$f" > "$OUT/gen/$name.m"
done

SDK=$(xcrun --sdk iphoneos --show-sdk-path)
xcrun --sdk iphoneos clang -target arm64-apple-ios17.0 -fobjc-arc -g -O0 \
    -I"$SRC" -I"$SRC/Redesigned/Artist" -I"$OUT/gen" -isysroot "$SDK" \
    -Wno-deprecated-declarations \
    "$HARNESS_DIR/main.m" "$HARNESS_DIR/stubs.m" \
    "$OUT"/gen/*.m \
    "$SRC"/Core/SGLog.m "$SRC"/Core/SGPrefs.m "$SRC"/Core/SGViewTree.m "$SRC"/Core/SGGlass.m \
    "$SRC"/Core/SGBackdrop.m "$SRC"/Core/SGFlagForce.m "$SRC"/Core/SGUIMode.m \
    "$SRC"/Redesigned/Kit/SGRTokens.m "$SRC"/Redesigned/Kit/SGRPalette.m "$SRC"/Redesigned/Kit/SGRField.m "$SRC"/Redesigned/Kit/SGRFlow.m \
    "$SRC"/Redesigned/Kit/SGRGlass.m "$SRC"/Redesigned/Kit/SGRGlyph.m "$SRC"/Redesigned/Kit/SGRRestyle.m \
    "$SRC"/Redesigned/Kit/SGRActionRow.m "$SRC"/Redesigned/Kit/SGRDownload.m "$SRC"/Redesigned/Kit/SGRHeaderInfo.m \
    "$SRC"/Redesigned/Kit/SGRedesign.m \
    -framework UIKit -framework QuartzCore -framework CoreGraphics -framework CoreImage -framework Foundation -framework Symbols \
    -o "$APP/ArtistHarness"

cat > "$APP/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleExecutable</key><string>ArtistHarness</string>
<key>CFBundleIdentifier</key><string>com.vojta.artistharness</string>
<key>CFBundleName</key><string>ArtistHarness</string>
<key>CFBundleVersion</key><string>1</string>
<key>CFBundleShortVersionString</key><string>1.0</string>
<key>UIUserInterfaceStyle</key><string>Dark</string>
<key>UILaunchScreen</key><dict/>
<key>UIApplicationSceneManifest</key><dict>
  <key>UIApplicationSupportsMultipleScenes</key><false/>
</dict>
</dict></plist>
PLIST

cp -R "$APP" "$OUT/Payload/ArtistHarness.app"
(cd "$OUT" && zip -qry "$IPA" Payload)
rm -rf "$OUT/Payload" "$OUT/gen"
echo "built unsigned device IPA: $IPA"
echo "Import it into a signing/launch tool such as LiveContainer or zContainer; this script does not sign it."
