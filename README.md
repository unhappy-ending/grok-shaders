# Grok Shaders

Welcome to **Grok Shaders**, a collection of post-processing shaders for [ReShade](https://reshade.me/), designed to enhance visuals in games and applications. These shaders, built with HLSL and compatible with **ReShade 6.4.0**, offer a range of effects from color adjustments to zooming, all with intuitive UI controls and comprehensive documentation. Crafted as an experimental project to explore the capabilities of AI-assisted shader development, Grok Shaders aims to provide accessible, high-quality visual enhancements for enthusiasts, modders, and developers.

## Features

- **Modular Shaders**: Each shader is a standalone `.fx` file, easy to install and combine.
- **Intuitive UI**: Sliders and toggles are organized under dedicated categories (e.g., `Grok Exposure`, `Grok Zoom`) in the ReShade UI.
- **Comprehensive Annotations**: Detailed comments in each shader explain purpose, logic, and usage, making them developer-friendly.
- **Lightweight Performance**: Optimized for real-time use with minimal overhead.
- **Open Source**: Licensed under [MIT License](#license), welcoming ideas and feedback.

## Available Shaders

| Shader | File | Description | UI Controls |
| --- | --- | --- | --- |
| **ColorInversion** | `grok3_ColorInversion.fx` | Inverts RGB colors for a negative film effect. Supports a debug mode (split-screen) when enabled. | Toggle: `Enable Color Inversion` (on/off) |
| **Gamma** | `grok3_Gamma.fx` | Adjusts image gamma for gamma correction, altering the non-linear brightness response. Supports a debug mode (visualization boxes). | Slider: `Gamma` (-1.0 to 1.0) |
| **Exposure** | `grok3_Exposure.fx` | Scales RGB values to simulate camera exposure, darkening or brightening the image. | Slider: `Exposure` (0.0 to 2.0) |
| **SepiaTone** | `grok3_SepiaTone.fx` | Applies a vintage sepia tone by blending original colors with a sepia matrix. | Slider: `Sepia Intensity` (0.0 to 1.0) |
| **Zoom** | `grok3_Zoom.fx` | Zooms the image in or out, centered at the screen’s middle. | Slider: `Zoom Level` (-0.75 to 10.0) |

## Installation

1. **Install ReShade**:
   - Download and install [ReShade 6.4.0](https://reshade.me/) for your game or application.
   - Follow ReShade’s setup instructions to inject it into your target executable.

2. **Add Shaders**:
   - Clone or download this repository: `git clone https://github.com/unhappy-ending/grok-shaders.git`.
   - Copy the `.fx` files (e.g., `grok3_ColorInversion.fx`) to ReShade’s shaders directory.

3. **Enable Shaders in ReShade**:
   - Launch your game/application with ReShade enabled.
   - Open the ReShade UI (default key: `Home`).
   - Ensure ReShade effects are enabled (check the toggle in the UI, often at the top).
   - Select the desired technique (e.g., `grok3_Exposure`) from the list to enable it.
   - Adjust settings under the shader’s UI category (e.g., `Grok Zoom` for `ZoomLevel`).

## Usage

Each shader is controlled via the ReShade UI, with settings organized under a `Grok` category (e.g., `Grok Exposure`, `Grok Sepia Tone`). Below are brief usage tips:

- **ColorInversion**:
  - Toggle `Enable Color Inversion` to invert colors (on) or show the original image (off).
  - Enable `ENABLE_DEBUG=1` via ReShade’s preprocessor to see a split-screen (left: inverted, right: original) when inversion is on.
- **Gamma**:
  - Adjust `Gamma` (-1.0 to 1.0) for gamma correction. Negative values darken, positive values brighten.
  - Use `ENABLE_DEBUG=1` via preprocessor to see a rectangle with 11 discrete boxes to visualize the gamma effect.
- **Exposure**:
  - Set `Exposure` (0.0 to 2.0) to darken (e.g., 0.5) or brighten (e.g., 1.5) the image. 1.0 = original.
  - Beware of clipping at high values (e.g., 2.0).
- **SepiaTone**:
  - Adjust `Sepia Intensity` (0.0 to 1.0) for a vintage look. 0.0 = original, 1.0 = full sepia.
- **Zoom**:
  - Set `Zoom Level` (-0.75 to 10.0) to zoom out (negative), zoom in (positive), or no zoom (0.0).

### Configuring Debug Modes
Some shaders (`ColorInversion`, `Gamma`) support a debug mode via the `ENABLE_DEBUG` preprocessor:
1. In the ReShade UI, double-click the `ENABLE_DEBUG` value at the bottom of the shader’s settings and set it to `1`.
2. Reload the shader (ReShade UI: `Home > Reload`).
3. Debug mode for `ColorInversion` shows a split-screen comparing the effect (left) vs. original (right). For `Gamma`, it shows a rectangle with 11 discrete boxes to visualize the gamma effect.

## Troubleshooting

If a shader or UI behaves unexpectedly:

1. **Check ReShade Effects**:
   - Ensure ReShade effects are not toggled off in the UI (check the effects toggle, often at the top).
   - If effects are disabled, enable them and reload the shaders.

2. **Check Installation**:
   - Verify `.fx` files are in ReShade’s shaders directory.
   - If missing, recopy the files and reload ReShade.

3. **Verify UI**:
   - Ensure sliders/toggles appear under their `Grok` category (e.g., `Grok Zoom`).
   - If missing, reload ReShade or verify installation.

4. **Test Functionality**:
   - **ColorInversion**: Toggle on/off, test debug split-screen with `ENABLE_DEBUG=1`.
   - **Gamma**: Adjust `Gamma`, verify darkening (e.g., -0.5) or brightening (e.g., 0.5).
   - **Exposure**: Test `Exposure = 0.0` (black), `1.0` (original), `2.0` (bright).
   - **SepiaTone**: Test `Sepia Intensity = 0.0` (original), `1.0` (sepia).
   - **Zoom**: Test `Zoom Level = 0.0` (no zoom), `-0.75` (zoom out), `1.0` (zoom in).

5. **Check Compilation**:
   - View ReShade’s log (Log tab) for errors loading `.fx` files.

6. **ReShade Version**:
   - Confirm ReShade 6.4.0. Other versions may affect UI or shader behavior.

7. **Report Issues**:
   - Open an issue on this repository with ReShade’s log or a description of the problem.

## Ideas

We welcome ideas to enhance Grok Shaders! Feel free to suggest:
- New shaders (e.g., vignette, grayscale, bloom).
- Debug modes for additional shaders (e.g., Zoom, SepiaTone).
- Advanced features (e.g., per-channel controls, custom effects).
- UI enhancements or performance optimizations.
- Creative use cases for combining shaders.

Submit your ideas via a GitHub issue, and let’s discuss how to make Grok Shaders even better!

## License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute the shaders, provided the license terms are followed.

## Acknowledgments

Grok Shaders is an experimental project to explore AI-assisted shader development, led by **unhappy-ending**, a non-coder passionate about pushing creative boundaries. This project tests what’s possible with AI tools like Grok 3, created by xAI, as a ReShade assistant. Special thanks to:

- **unhappy-ending** for envisioning and driving this project, proving that creativity and experimentation can yield powerful results without deep coding expertise.
- **Grok**, created by xAI, for authoring this README and assisting in shader development.
- The ReShade community for their powerful framework and documentation.
- The open-source community for inspiring accessible, high-quality tools.

Built with ❤️ as a testament to curiosity and collaboration.

## Contact

Have questions, ideas, or issues? Open an issue on this repository or reach out via GitHub. Let’s make visuals epic together!

---

Happy shading! 🎨
