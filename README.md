# Yazılım Yolu Theme

Four color themes for Visual Studio Code, built from the brand colors of
Yazılım Yolu: **purple**, **teal** and **navy**. The interface stays calm and
consistent, while a rich syntax palette keeps code easy to scan.

## Themes

| Theme                       | Type  | Best for                                                                  |
| --------------------------- | ----- | ------------------------------------------------------------------------- |
| **Yazılım Yolu Dark**       | Dark  | Everyday use. Deep navy background with vivid, balanced syntax colors.    |
| **Yazılım Yolu Extra Dark** | Dark  | Dim rooms and late nights. Same syntax colors on a darker background.     |
| **Yazılım Yolu Light**      | Light | Bright environments. Crisp syntax colors on a near-white background.      |
| **Yazılım Yolu Soft Light** | Light | Long sessions in daylight. Dimmer background and softer text, less glare. |

## Installation

1. Open the **Extensions** view: `Ctrl+Shift+X` (macOS: `Cmd+Shift+X`).
2. Search for **Yazılım Yolu** and click **Install**.
3. Open the theme picker with `Ctrl+K Ctrl+T` (macOS: `Cmd+K Cmd+T`) and
   choose one of the four themes.

You can also install it from Quick Open (`Ctrl+P` / `Cmd+P`):

```text
ext install yazilim-yolu.yazilim-yolu-theme
```

Using **Cursor**, **VSCodium** or **Windsurf**? The theme is also published on
[Open VSX](https://open-vsx.org/extension/yazilim-yolu/yazilim-yolu-theme), so
you can install it from the Extensions view of those editors too.

## Colors

### Accents

| Color  | Hex       | Used for                                                                           |
| ------ | --------- | ---------------------------------------------------------------------------------- |
| Purple | `#7C3BED` | Primary accent: buttons, focus borders, side bar badges, keywords                  |
| Teal   | `#3ABACD` | Active state: Activity Bar icon and badge, active tab, cursor, links, find matches |
| Navy   | `#232D5B` | The base of the dark backgrounds                                                   |

### Syntax

| Token                          | Dark      | Light     |
| ------------------------------ | --------- | --------- |
| Keywords                       | `#9570ED` | `#6E25EB` |
| Control flow (`if`, `return`)  | `#B688F2` | `#8927D0` |
| Functions and methods          | `#4299EE` | `#225BC5` |
| Strings                        | `#5CCAA3` | `#1C8E69` |
| Types and classes              | `#41C2B7` | `#0D8469` |
| Properties and object keys     | `#79CAD6` | `#0E7083` |
| Numbers and constants          | `#DB9658` | `#A35511` |
| Parameters                     | `#C28DF1` | `#7F2CD4` |
| Decorators and macros          | `#E0B563` | `#8E6200` |
| Tags, `this` / `self`          | `#E4658A` | `#B23557` |
| Regular expressions            | `#44C2D3` | `#0D8799` |
| Comments                       | `#5C6280` | `#8B92AE` |

Extra Dark uses the same syntax colors as Dark. Soft Light uses Light's colors,
slightly deepened where needed to stay readable on its dimmer background.

In the dark themes, every syntax color except comments has a contrast ratio of
at least 5:1 against the editor background, above the WCAG AA level for text.

## Language support

The themes work with any language, and include hand-tuned scopes for:

TypeScript, JavaScript, JSX/TSX, Python, Rust, Go, C, C++, C#, Java, PHP, Ruby,
CSS, SCSS, LESS, HTML, JSON, YAML, TOML, INI, SQL, GraphQL, Markdown,
Dockerfile, Makefile and shell scripts.

**Semantic highlighting** is enabled, so languages with a semantic token
provider (such as TypeScript, Python, Rust, Go and C#) get more precise colors
for classes, parameters, properties and read-only variables.

The themes also style the integrated terminal, Git decorations, diff views and
the Activity Bar in VS Code's modern layout.

## Feedback

Found a color that is hard to read, or a language that looks off? Please
[open an issue](https://github.com/yazilim-yolu/vscode-theme/issues). A
screenshot and the file type help a lot.

## License

[MIT](LICENSE) © Yazılım Yolu
