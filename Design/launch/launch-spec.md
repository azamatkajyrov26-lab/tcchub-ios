# Launch Screen Spec

- Background: `#1B2A4A` (brand navy) in both light and dark mode (identical).
- Centered logo: `logo-mark-light.png` (gold stroke + gold T mark on navy).
  - Size: 160 × 160 pt (320/480 px @2x/@3x).
  - Vertically and horizontally centered.
- No text. No spinner. No version number.
- Respect safe area; logo never touches status bar / home indicator.
- iPad: identical layout, logo centered.
- Implementation: `LaunchScreen.storyboard` with a single `UIImageView` constrained to superview center, width=160, aspect=1:1, `contentMode=scaleAspectFit`, background color named `BrandNavy`.
