# monochrome

**Liquid Glass redesign and native UI enhancements for Spotify on iOS.**

Monochrome is a Theos-based iOS customization project with two distinct appearance modes. Choose the native Spotify interface with selected enhancements, or switch to a redesigned interface built around a dark, Liquid Glass-inspired visual style.

## Features

### Native

Keep Spotify's own screens while enabling selected interface and behavior changes, including configurable hide options, glass header buttons, a Home gradient, an AMOLED option, and an accent color.

### Redesigned

Use Monochrome's alternative interface, including:

- A glass tab bar, search field, and now-playing bar.
- A redesigned player and lyrics page, with Apple Music-style lyrics always shown.
- A decluttered Home screen and Search categories on tinted glass.
- A Library with a large title, and redesigned playlist, album, and artist pages.
- A consistent dark appearance and a separate accent color.

The two interface modes are mutually exclusive. The selected mode is read at launch, so changing it requires restarting Spotify.

### Shared features

Features that do not depend on either interface mode include privacy options, lyrics sources, gestures, blocked artists, forced flags, vibrations, playback speed and pitch controls, and Live Activity support.

## Compatibility

- **Native mode:** iOS 16.1 and later.
- **Redesigned mode:** iOS 26 and later. The redesign relies on the system's Liquid Glass appearance and is unavailable on earlier iOS versions.

On iOS versions below 26, the redesign option is unavailable and its settings are disabled.

## Build and install

The project uses Theos. On a macOS development environment configured for Theos and the required Apple build tools, the repository's top-level Makefile provides these entry points:

```sh
make build    # Build the package and FLEX-enabled IPA into out/
make release  # Build the release IPA without FLEX
make install  # Build, sign, and install over USB
```

`make install` uses the signing setup configured for your device. To include FLEX with an install build, run:

```sh
make install FLEX=1
```

The tweak can also be built directly from its directory:

```sh
env -u MAKELEVEL gmake -C tweak clean package
```

## Development tools

The top-level Makefile also includes utilities for inspecting Spotify screens and collecting diagnostics:

```sh
make trees                         # Record view trees from a FLEX-enabled device build
make session                       # Record clean screen trees interactively
make log                           # Stream Monochrome log lines from the device
make flags                         # Regenerate the remote-config flag list
```

The `harness/` directory contains standalone page harnesses for developing and inspecting selected redesigned screens without a phone. Each harness has its own README with build and usage instructions.

## Project layout

| Path | Purpose |
| --- | --- |
| `tweak/Sources/Shared/` | Behavior and data shared by both interface modes. |
| `tweak/Sources/Native/` | Changes to Spotify's native screens. |
| `tweak/Sources/Redesigned/` | The redesigned interface and its components. |
| `tweak/Sources/App/` | Settings entry points, combined settings pages, and the introductory tour. |
| `tweak/Sources/Core/`, `Settings/`, `Headers/`, `Diagnostics/` | Shared infrastructure, settings, headers, and diagnostics. |
| `scripts/` | Build pipeline, layer checks, and device inspection tools. |
| `harness/` | Standalone development harnesses for selected screens. |
| `docs/` | Project documentation and screenshots. |

The source layers are deliberately separated. `scripts/check-layers.sh` checks the import boundaries as part of the build; see `AGENTS.md` for the detailed contributor guide and architecture rules.

## Acknowledgements

Monochrome includes vendored audio-processing code used by its audio effects. See the relevant notices in the repository for third-party licensing details.
