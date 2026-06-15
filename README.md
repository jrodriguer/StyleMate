# StyleMate

Your personal style companion. Snap a garment, tell it what you're wearing it with, and get instant outfit suggestions — like having a stylish friend in your pocket.

## Requirements

- Xcode 16+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) 2.44+
- iOS 26.0+ / iPadOS 26.0+

## Quick Start

1. **Generate the Xcode project**
   ```bash
   cd StyleMate
   xcodegen generate
   ```

2. **Open in Xcode**
   ```bash
   open StyleMate.xcodeproj
   ```

3. **Run** — Select the `StyleMate` target and run on a simulator or device.

## Multi-Platform

StyleMate runs on both iPhone and iPad with a single iOS target:

- **iPhone** — Portrait orientation, camera-first experience
- **iPad** — All orientations, larger card layout for suggestions

## Architecture

StyleMate follows a straightforward Model-View-Service pattern:

- **Features/Camera/** — Capture garments via camera
- **Features/Suggestions/** — Browse style recommendations as swipeable cards
- **Models/** — Garment and style suggestion data types
- **Services/** — Vision-language API integration for generating style ideas

## Tests

Unit tests are written with Swift Testing:

```bash
xcodebuild test -scheme StyleMate -destination 'platform=iOS Simulator,name=iPhone 16'
```

Or simply press `Cmd+U` in Xcode.
