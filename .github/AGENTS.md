<!-- AGENT_DIRECTIVES v2 -->

Priority: Follow these directives unless they conflict with system/developer instructions or safety rules.

## System Context

You are an AI agent specialized in Swift and JavaScript development. This document defines mandatory rules for consistent, secure and maintainable software development practices. You MUST follow this document precisely, including all of the sections below:

- Project Overview (MUST read fully)
- Pre-Implementation Checklist (MUST read fully)
- Bridge Rules (MUST read fully)
- Code style guidelines (MANDATORY)
- SwiftLint Compliance (MANDATORY)
- Development best practices (Adhere to best practices at all times.)
- Swift Concurrency (Swift 6)
- Project Structure
- Style Lifecycle
- Error Handling
- Privacy
- Tests
- Pull Request Template

## Project Overview

This repository is a SDK written in Swift, and is a swift package compatible with Swift Package Manager. It wraps the MapTiler JS SDK via Bridge architecture written in /Sources/Bridge folder. It uses maptiler-sdk.umd.min.js from /Sources/MapTilerSDK/Resources folder and bridges the functions from JS into the Swift. Bridging process is described in detail in Bridge Rules section and MUST be read fully and followed THOROUGHLY. API reference for the JS is found in /js/docs folder and you can search it through index.html or with grep on any file within the docs folder. You MUST always refer to docs before wrapping any functions.

### Main Components

- UI: MTMapView hosts a WKWebView rendering Resources/MapTilerMap.html, which loads the MapTiler JS SDK.
- Bridge: Public Swift APIs call Commands which serialize to JS, executed via WebViewExecutor; results decode through MTBridgeReturnType.
- Lifecycle: EventProcessor listens to JS-posted events, updates MTMapView state (style, isInitialized) and notifies delegate blocks.
- Safety: Most map mutations happen after didLoad/isReady; style updates can reset layers—queueing handled within MTStyle.
- Desired functionality from JS is bridged to Swift by creating corresponding MTCommand to it, adding the wrapper in MTMapView extension and exposing the public API for Swift developers.
- MTBridge class is responsible for executing the MTCommand.
- MTCommand is a protocol that defines what JS code is to be executed on the webview executor.
- WebViewExecutor executes the evaluateJavascript on the web view.
- JS used is the MapTiler SDK for JS, and its API reference is found in /js/docs and you can search it through indext.html or with grep on any file within the docs folder.

## Pre-Implementation Checklist
  Before writing ANY new code, you MUST:
  - Search for existing related types: `Grep pattern="MT[TypeName]|[RelatedConcept]"`.
  - Read similar existing implementations completely.
  - Identify the established patterns and types used.
  - Confirm no existing types can be reused before creating new ones.
  - Follow SwiftLint rules defined in `.swiftlint.yml` (4-space indentation, trailing newlines, etc.).
  - Don't proceed until all search/pattern analysis is complete.
  - Concurrency audit (Swift 6):
    - Use `@MainActor` for any API touching `MTMapView`/UIKit or bridge execution.
    - Only add `Sendable` where required (types crossing concurrency domains or stored/used across tasks).
    - Prefer `Sendable, Codable` for new public value types that are passed across async boundaries; avoid
      `@unchecked Sendable` unless absolutely necessary with a safety comment.
    - Ensure changes are buildable with Swift 6 toolchain (see `Package.swift` tools version).


## Bridge Rules

MUST follow this end-to-end flow when wrapping a JS API into Swift:

1) Discover and design
- Read the JS API in MapTiler SDK for JS docs; determine parameters, defaults, and return type.
- Define a Swift `struct` conforming to `MTCommand` with strongly typed, Codable parameters.

2) Encode parameters
- Use existing Codable helpers to build a compact JSON payload; avoid manual string concat where possible.
- Validate/clamp numeric ranges in Swift prior to execution (zoom, pitch, bearing, durations).

3) Implement `toJS()`
- Build a `JSString` that calls the JS API. Prefer passing a single options JSON object.
- If easing functions or callbacks are needed, convert to a JS expression string (see existing commands for `easing.toJS()`).

4) Choose execution path and return type
- For commands with no meaningful return: `runCommand(_:)`.
- For numeric result: `runCommandWithDoubleReturnValue(_:)`.
- For boolean: `runCommandWithBoolReturnValue(_:)`.
- For string: `runCommandWithStringReturnValue(_:)`.
- For coordinates: `runCommandWithCoordinateReturnValue(_:)`.
- If a new return type is required, extend `MTBridgeReturnType` in a focused change.

5) Public API surface
- Add a thin convenience method on `MTMapView` (or a relevant extension) that:
  - Ensures the map/style are ready (`didLoad`/`isReady`).
  - Validates inputs and applies sensible defaults.
  - Calls the bridge using the appropriate `runCommand*` helper.
  - Surfaces a completion with `Result<…, MTError>` or `async` variant.

6) Threading and lifecycle
- MUST run on the main thread when touching `MTMapView` or UIKit.
- Avoid firing commands before the WebView/bridge is available; prefer queuing until ready.

7) Testing
- Unit test: parameter encoding and range clamping.
- Contract test: `toJS()` shape for simple cases (e.g., duration only).

Example skeleton:

```swift
package struct RotateTo: MTCommand {
    var bearing: Double
    var durationMs: Double?

    package func toJS() -> JSString {
        struct Options: Codable { let bearing: Double; let duration: Double? }
        let opts = Options(bearing: bearing, duration: durationMs)
        let json = opts.toJSON() ?? "{}"
        return "\(MTBridge.mapObject).rotateTo(\(json));"
    }
}

public extension MTMapView {
    func setBearing(_ bearing: Double, durationMs: Double? = nil, completion: ((Result<Void, MTError>) -> Void)? = nil) {
        let clamped = (bearing.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
        runCommand(RotateTo(bearing: clamped, durationMs: durationMs), completion: completion)
    }
}
```

## Code style guidelines (MANDATORY)

- Each public entity is suffixed with MT (i.e. MTMapView, MTMapStyle).
- Classes, Structs, Protocols and Enums use PascalCase (i.e. MTMapOptions, MTMapViewDelegate).
- Variables and Functions use camelCase (i.e. zoomIn(), mapOptions).
- Constants are declared with "let" keyword inside of an Enum, Extension or Struct and should be camelCase.
  
- 4 spaces are used for indentation.
- Function default parameters should be kept at the end of parameters list.
- End files with exactly one trailing newline (no extra blank lines at EOF).
- Line length: 120 characters max (code and comments). Wrap doc comments accordingly.

## SwiftLint Compliance (MANDATORY)
- ALWAYS follow the rules defined in `.swiftlint.yml` in the root directory.
- Key rules: 4-space indentation, trailing newlines, closure spacing, operator whitespace.
- Test files are excluded from linting but should still follow general style guidelines.
- Before completing implementation, mentally verify compliance with enabled opt-in rules.

## Development best practices

- Prefer `public` for public API; use `open` only when subclassing/overriding by SDK consumers is intended.
- All internal implementation that we do not want exposed in the API should use private and fileprivate access modifiers.
- Use package modifier for functions and properties that you want to keep private but have accessible in different modules within the package.
- When introducing new error types always conform to Error protocol.
- Write a documentation comment for every public declaration.
- We should aim for high unit test coverage, but be sensible.
- Code will be linted with SwiftLint using rule defined in .swiftlint.yml file in the root of the repo.
- Each file should have a copyright header.

## Swift Concurrency (Swift 6)

- Main thread safety:
  - Mark UI/`MTMapView`-facing APIs and bridge executors as `@MainActor`. Do not access UIKit/WebKit off the main actor.
- Sendability:
  - Add `Sendable` only when a type must be safely shared across concurrency domains. Do not blanket-annotate.
  - Public value-models that are used in async APIs should conform to `Sendable` (and typically `Codable`).
  - Avoid `@unchecked Sendable` unless invariants guarantee thread-safety; document the rationale inline.
- Buildability:
  - Code must compile cleanly under Swift 6 (`// swift-tools-version: 6.0`).
  - Keep non-UI model/tests platform-agnostic when possible; avoid UIKit in Linux-only test contexts.
  - Prefer small, testable units (commands, options) with `toJS()` contract tests over UI-bound tests.

## Project Structure

### Top-Level

- README.md: Usage, features, UIKit/SwiftUI snippets, sources/layers, annotations, installation.
- CHANGELOG.md, CONTRIBUTING.md, LICENSE: Project meta.
- .swiftlint.yml: Lint rules.
- .spi.yml: Swift Package Index config.
- .github/, .githooks/, scripts/: CI, hooks, and scripts scaffolding.

### Library: Sources/MapTilerSDK

- Map/: Core UI and map API.
    - MTMapView: Main UIView backed by WKWebView; exposes map/style APIs, delegates, and lifecycle (didLoad, isReady, isIdle).
    - MTMapViewContainer: SwiftUI wrapper.
    - MTMapOptions + Options/: Camera, padding, animation, gestures config.
    - Style/: MTStyle, reference styles/variants, glyphs/terrain/tile scheme, style errors.
    - Gestures/: Gesture types and services (pan, pinch/rotate/zoom, double tap).
    - Types/: Shared types (e.g., LngLat, MTColor, MTPoint, MTLight, source data).
    - Extensions/: Glue to the bridge/delegate protocols.
- Bridge/: Swift ↔️ JS bridge via WebView.
    - MTCommand: Protocol for JS-callable commands.
    - MTBridge: Executes commands via an executor.
    - WebViewExecutor: WKWebView evaluator; error handling, verbose logging.
    - WebViewManager: WebView setup, script messaging, navigation delegate.
    - MTBridgeReturnType, MTError: Typed return decoding and error surface.
- Commands/: Strongly-typed wrappers that turn Swift calls into JS invocations.
    - Config/: API key, telemetry, units, caching, session logic.
    - Navigation/: Camera controls (flyTo, easeTo, jumpTo, pan/zoom/bearing/pitch/roll, bounds, padding).
    - Style/: Add/remove sources and layers, set style, language, light, glyphs, projection, terrain.
    - Annotations/: Add/remove markers and text popups, set coordinates, batch ops.
    - Gestures/: Enable/disable gesture types.
    - Controls/: Add logo control.
- Annotations/: Public annotation APIs (MTMarker, MTTextPopup, MTCustomAnnotationView, base MTAnnotation).
- Events/: Event pipeline (EventProcessor, buffer) that feeds MTMapViewDelegate and content delegates.
- Helpers/: Codable helpers, color/coordinates converters, benchmarking.
- Logging/: Log level/types and adapters (MTLogger, OSLogger).
- Root files: MTConfig (API key, session logic, log level), MTEvent, MTLanguage, MTLocationManager, MTUnit.
- Resources/: Embedded assets for the web map container.
    - MapTilerMap.html: Base HTML container.
    - MapInit.js, MapEventSetUp.js: Map bootstrapping and event wiring.
    - maptiler-sdk.umd.min.js(.map), maptiler-sdk.css: MapTiler JS SDK bundle and styles.

### Tests

- Tests/MapTilerSDKTests: Unit tests using swift-testing.
    - Helpers: coordinate and color conversions, language decoding.
    - Additional suites: navigation and style tests.


## Style Lifecycle

MUST wait for `didLoad`/`isReady` before mutating style or layers. Changing the reference style resets layers; re-add required sources/layers after `SetStyle`. Prefer batch commands where available. When enabling terrain or projection changes, verify map idleness before subsequent camera moves.

## Error Handling

- Retry once on transient `WKError` bridge failures (excluding unsupported type warnings).
- Return clear, user-facing messages with the failed command and suggested fix.
- Treat unsupported return types as warnings; choose a safer path or request input.

## Privacy

- Never log API keys. Redact sensitive values from structured logs.
- Avoid sending exact user coordinates unless necessary; round or fuzz where acceptable.


Cross-reference implementation against original prompt requirements before making pull request, and make sure to follow the Pull Request Template below:

## Pull Request Template

[Link to related issue]

## Objective
What is the goal?

## Description
What changed, how and why?

## Acceptance
How were changes tested?
