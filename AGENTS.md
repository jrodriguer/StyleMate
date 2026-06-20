# StyleMate — Agent Guide

## Build & Run

```bash
xcodegen generate   # regenerate .xcodeproj from project.yml
open StyleMate.xcodeproj
```

Select the **StyleMate** target and run on a simulator or device.

## Project Tree

```
StyleMate/
├── StyleMate/                  # iOS app (iPhone + iPad)
│   ├── App/
│   │   └── StyleMateApp.swift  # @main entry point
│   ├── Features/
│   │   ├── Camera/
│   │   │   ├── CameraView.swift    # Garment capture screen
│   │   │   └── ImagePicker.swift   # UIKit camera wrapper
│   │   └── Suggestions/
│   │       └── SuggestionsView.swift  # Style result cards
│   ├── Models/
│   │   └── Garment.swift        # Garment, StyleSuggestion, StyleQuery
│   ├── Services/
│   │   └── StyleService.swift   # Vision API integration
│   ├── Resources/
│   │   └── Assets.xcassets/
│   └── Preview Content/
│       └── Preview Assets.xcassets/
├── StyleMateTests/
│   └── StyleMateTests.swift     # Swift Testing unit tests
├── project.yml                  # XcodeGen project spec
├── .gitignore
├── AGENTS.md
└── README.md
```

## Targets

| Target | Type | Platform | Deployment |
|--------|------|----------|------------|
| StyleMate | Application | iOS | 26.0 |
| StyleMateTests | Unit Test | iOS | 26.0 |

## Dev Conventions

- **Swift 6.2** with strict concurrency checking
- **SwiftUI** only, no UIKit except `UIImagePickerController` wrapper
- **MV pattern**: Models in `Models/`, views in `Features/*/`, services in `Services/`
- Use `#Preview` for all new views
- Use `@State` for local view state, services as `actor` for thread safety
- Format: 4-space indentation, no semicolons

## Tests

- Written with **Swift Testing** (not XCTest)
- Test target: `StyleMateTests`
- Run with `Cmd+U` in Xcode or via `xcodebuild test -scheme StyleMate`
- Use `#expect(...)` and `try #require(...)` instead of XCTAssert

## PR Flow

1. Create a feature branch from `main` — derive name from changes (e.g. `fix/login-crash`, `feat/onboarding`)
2. Write code + update or create tests in `StyleMateTests/` for every new/modified file
3. Run tests — `Cmd+U` in Xcode or `xcodebuild test -scheme StyleMate`
4. Review the code — check diff, naming, conventions, force-unwraps, and test coverage
5. Push and open PR — derive title/body from changes (describe what & why, not how)
6. Merge with `--squash` to `main`
7. Delete remote branch
8. Checkout `main` and pull the latest changes
9. Prune local branches with `git fetch --prune` and `git branch -d <branch-name>`