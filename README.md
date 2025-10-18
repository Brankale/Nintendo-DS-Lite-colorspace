> [!NOTE]
> Some parts of this guide were developed with AI assistance.

> [!WARNING]
> I'm not a color scientist or expert. This guide may contain inaccuracies or misleading information. Please take it with a grain of salt. If you notice any issues, feel free to open an issue.

# Index

- [Displays types](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#displays-types)
   - [Measurements tools](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#measurements-tools) 
- [Handhelds status report](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#handhelds-status-report)
- [Do the measurements](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#do-the-measurements)
   - [Introduction](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#introduction)
   - [Measurements guide for emissive displays](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#measurements-guide-for-emissive-displays)
   - [Measurements report (template)](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#measurements-report-template)
   - [Measurements Validation](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#measurements-validation)
- [Retroarch Shaders](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#retroarch-shaders)
   -  [Shader parameters](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#shader-parameters)
      - [Chromatic Adaptation](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#chromatic-adaptation)
   -  [Debug Shader parameters](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#debug-shader-parameters)
      - [Show out of Gamut colors](https://github.com/Brankale/Handheld-Color-Space-Project/edit/main/README.md#show-out-of-gamut-colours) 
- [Colorspace conversion Math](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#colorspace-conversion-math)
   - [Calculate RGB => CIE XYZ conversion matrix](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#calculate-rgb--cie-xyz-conversion-matrix)
   - [Calculate the Chromatic Adaptation Transform (CAT) Matrix](https://github.com/Brankale/Handheld-Color-Space-Project/blob/main/README.md#calculate-the-chromatic-adaptation-transform-cat-matrix)

# Displays types

- `Emissive`: the display **emits its own light** (no external illumination needed).
- `Reflective`: the display **does not emit light**; it reflects ambient light. Pixels modulate reflection, rather than emitting light.
- `Transflective`: **hybrid** of emissive and reflective. A backlight is present, but the display can also use ambient light (via a partially reflective layer).

## Measurements tools

Depending on the display type, you must use the appropriate meter to ensure accurate measurements. Here is a summary table:

| Meter  | Emissive | Reflective | Transflective |
| ------------- | :-------------: | :-------------: | :-------------: | 
| Colorimeter        | ✅ good accuracy | ❓ | ❓ |
| Spectroradiometer  | ✅ highest accuracy | ❓ | ❓ |
| Spectrophotometer  | ⚠️ not recommended (*) | ✅ | ❓ |

(*) A spectrophotometer primarily measures reflected light from surfaces. Some models have an “emissive mode,” but they’re generally slower, less sensitive at low light, and not ideal for bright HDR peaks or very dark near-black, common in emissive displays.

# Handhelds status report

> [!NOTE]
> The table is not exhaustive.

| Handheld  | Display Type | Display Data Collected? | Known Manufacturers | Measurements Notes |
| ------------- | :-------------: | :-------------: |  :-------------: | :------------- |
| `Game Boy` |  Reflective | 🔴 | Unknown | |
| `Game Boy Pocket` |  Reflective | 🔴 | Unknown | |
| `Game Boy Light` |  Emissive | 🔴 | Unknown | |
| `Game Boy Color` |  Reflective | 🔴 | Unknown | |
| `Game Boy Micro` |  Emissive | 🔵 | Unknown | - unknown manufacturer |
| `Game Boy Advance` |  Reflective | 🔴 | Unknown | | 
| `Game Boy Advance SP AGS-001` |  Emissive (frontlit on),<br> Reflective (frontlit off) | 🔴 | Unknown | |
| `Game Boy Advance SP AGS-101` |  Emissive | 🔵 | Unknown | - unknown manufacturer |
| `NDS Phat` |  Emissive | 🔵 | Unknown | - unknown manufacturer |
| `NDS Lite` |  Emissive | 🟡 | (2) Hitachi, Sharp | - unknown manufacturer<br>- greyscale gamma differs between reports (different manufacturers?) |
| `NDSi` |  Emissive | 🔴 | Unknown | |
| `NDSi XL` |  Emissive | 🔴 | Unknown |  |
| `3DS` |  Emissive | 🔵 | Unknown | - unknown manufacturer |
| `3DS XL` |  Emissive | 🔴 | Unknown |  |
| `2DS` |  Emissive | 🔴 | Unknown |  |
| `New 3DS` |  Emissive | 🔴 | Unknown | |
| `New 3DS XL` |  Emissive | 🟡 <br>[other info here - Erica Griffin](https://www.youtube.com/watch?v=QvDdaVZ7MCU) | Unknown | - only IPS top screen analyzed<br>- screen lottery<br>- unknown manufacturer |
| `New 2DS` |  Emissive | 🔴 | Unknown |  |
| `New 2DS XL` |  Emissive | 🔴 | Unknown | |
| `Wii U` |  Emissive | 🔴 | Unknown | |
| `Switch` |  Emissive | 🔴 <br>[info here - Erica Griffin](https://www.youtube.com/watch?v=QvDdaVZ7MCU) | Unknown | |
| `Switch Mini` |  Emissive | 🔴 | Unknown | |
| `Switch OLED` |  Emissive | 🔴 <br>[info here - GamingTech](https://www.youtube.com/watch?v=mYnUdYoh_xc) | Unknown | |
| `Switch 2` |  Emissive | 🔴 | Unknown | |

Legend:
- 🔴: No data available or not yet analyzed
- 🟡: Partial data available; some information missing  
- 🔵: Data available
- 🟢: Data available and verified by two or more screen reports

# Do the measurements

## Introduction

Handheld LCD screens present several challenges:
- color variations depending on the **viewing angle** (especially on TN panels).
- variation in **color tint/brightness/gamma** caused by the 'screen lottery' phenomenon in certain handhelds (e.g. the 3DS), where manufacturing tolerances cause units with the same nominal display model to exhibit distinct color characteristics. 
- different **screen manufacturers**: some handhelds have different screen manufacturers (e.g. NDS Lite has LCD screens coming from Hitachi and Sharp (1)(2)) which can cause color variations across different units of the same handheld.
- **screen protectors and touchscreens** (aka screen digitizers) can affect color accuracy, especially if they are old and have been exposed to sunlight, which can degrade the plastic and cause a yellowish tint.

The goal is to **measure the best possible scenario**, removing all the factors which can degrade image quality.

> [!IMPORTANT]
> Measurements of mods (e.g., IPS and OLED panel replacements) is allowed but only if clearly documented.

### Examples of "screen lottery"

<img width="600" alt="chromatic adaptation" src="https://github.com/user-attachments/assets/5c68e899-6484-4fdb-a915-a40d6258efcb"/>

GameBoy Advance SP AGS-??? by Pica200 ([libretro post link](https://forums.libretro.com/t/real-gba-and-ds-phat-colors/1540/295))

<img width="600" alt="chromatic adaptation" src="https://github.com/user-attachments/assets/94e169b0-469c-4f04-81e3-cea470034200"/>

GameBoy Advance SP AGS-001 by mckimiaklopa ([libretro post link](https://forums.libretro.com/t/real-gba-and-ds-phat-colors/1540/271))

## Measurements guide for emissive displays

### Environment setup

To achieve reproducible and accurate measurements, you must:

* **Let the screen warm up**:
  * Measuring too early can produce non-reproducible results and will not reflect the true visual experience. Leave the screen on and wait for the luminance and chromaticity to stabilize before recording the measurements. Depending on the screen type, this process can take anywhere from 5 to 30 minutes.
* **Remove external light sources**:
  * Avoid sunlight, lamps, and any other external light sources. Even small reflections or stray light can affect measurement accuracy.
  * For multiple screens (e.g., NDS family), cover the screens not being measured to prevent light leakage.
* **Plug in the charger for certain handhelds**:
  * Some devices (e.g., PSP-1000) require charging to reach maximum screen luminance.
* **Use full-screen color patches**:
  * Requires homebrew software on modded handhelds, hardware modifications, or special cartridges.
* **Optionally remove screen protectors or digitizers**:
  * Extra layers (e.g., touchscreen or protective films) can alter measurements, so removing them improves accuracy.
* **Colorimeter usage**:
  * **With screen protector**: Place the sensor in contact with the protector to keep it perpendicular, reduce light leakage, and minimize external light influence.
  * **Without screen protector**: Place the sensor directly on the screen but avoid pressing too hard to prevent distortion or Newton rings. Alternatively, position the meter very close to the screen, ensuring perpendicular alignment—small viewing angle changes can significantly affect color and brightness on TN panels.

### What to Measure

To accurately characterize a handheld screen’s colorspace, you should record the following data:
* **Chromaticity coordinates** of the three primaries (R, G, B).
* **Chromaticity coordinates of the white point (W)**.
* **Individual Gamma response of the three channels (R, G, B)**:
  * Use stepped ramps with increments of **10% or smaller** for greater accuracy.
  * Include additional fine measurements near **white (96%–99%)** and **black (1%–4%)** levels, as these regions are the most prone to errors.
* **Maximum luminance (full white)** of the display.
* **Minimum luminance (full black)** of the display.

If the handheld has multiple screens (e.g., Nintendo DS family), measure **both top and bottom panels**.
* In some systems (e.g., NDS Lite), the panels are identical, but the bottom screen includes a **touch layer** that can slightly degrade image quality.
* If you want to reduce workload, prioritize measuring the **non-touch screen**, as it represents the display’s best possible performance.

> [!IMPORTANT]
> Using only the greyscale gamma curve is not enough to get accurate results. To make things clear, think the greyscale gamma as the mean between the red gamma (γR), the green gamma (γG) and the blue gamma (γB) (this is an oversemplification, this is not actually a mean). You can have a greyscale gamma of 2.2 which seems great but this can be the results of both (γR = 2.2, γG = 2.2, γB = 2.2) and (γR = 2.9, γG = 2.2, γB = 1.5) which leads to completely different colors.

#### Example (using HCFR software)

R, G and B channels chromaticity coordinates (CIE xyY coordinates):
<img width="640" height="360" alt="Screenshot From 2025-09-03 16-44-40" src="https://github.com/user-attachments/assets/c5f60803-f372-4492-9f95-d2b5de59b2b2" />

White chromaticity coordinates (CIE xyY coordinates) + white/black luminance:
<img width="640" height="360" alt="Screenshot From 2025-09-03 16-44-50" src="https://github.com/user-attachments/assets/1f97ca9c-6f21-4f67-966b-7b58643b0e8f" />

Individual Red, Green and Blue gamma curves (10%-90%) + near black (1%-4%) & near white gamma (96%-99%):
<img width="640" height="360" alt="Screenshot From 2025-09-03 16-41-30" src="https://github.com/user-attachments/assets/0da55b1e-0ed9-4180-984f-b7dba6b7bda5" />
<img width="640" height="360" alt="Screenshot From 2025-09-03 16-42-56" src="https://github.com/user-attachments/assets/a7dbbe27-1221-4b59-b534-2eef6343097d" />
<img width="640" height="360" alt="Screenshot From 2025-09-03 16-43-21" src="https://github.com/user-attachments/assets/e3d8ee77-480a-4828-acb9-23a16e1e4623" />


## Measurements report (template)

- `author`: the author name of the measurements.
- `date`: the date of the measurement. This is important because screen colors degrade over time and with use. Recording the measurement date helps track screen aging and maintain accuracy.
- `handheld`: the measured handheld.
- **screen**
    - `type`: emissive / reflective / transflective
    - `position`: top / bottom (only if multiple screens are present).
    - `quantization`: the bit depth per color channel (e.g. NDS Lite has 6 bits per channel = 262.144 colors)
    - `manufacturer`: the manufacturer name of the measured screen.
- **meters**
    - `name`: name of the meter used.
    - `type`: colorimeter / spectroradiometer / spectrophotometer
- **measurements**
   - `software name`: the software name used to make the measurements (e.g., HCFR).
   - `software version`: the version of the software used to make the measurements.
   - `screen warm-up`: yes / no
   - `no external light sources`: yes / no
   - `charger`: yes / no
   - `no screen protector / touchscreen`: yes / no
- `notes`: any relevant info about the screen, the measurements etc.

> [!IMPORTANT]
> Always share your full measurement data in a readable format, along with the raw files (e.g., `.chc` files if you use HCFR). This ensures that others can review and verify your work.
> If you only share the final results (such as shaders or LUTs) without the underlying data, your work cannot be reproduced or improved upon.

## **Measurements Validation**

To validate the results of a colorspace conversion:

1. **Calibrate your display**
   * Ensure your display supports the target gamut.
   * Use a hardware colorimeter or spectroradiometer to calibrate your display to the target colorspace (e.g., sRGB, DisplayP3 (sRGB EOTF), P3-D65 (PQ EOTF), Rec. 2020). Ensure you use a colorimeter or spectroradiometer capable of accurately measuring wide-gamut colorspaces, as not all devices support them correctly.
   * If hardware calibration is not possible, use a high-quality display with verified calibration, but note that results may have small deviations.
3. **Disable all display enhancements**
   * Turn off dynamic contrast, local dimming, HDR, blue-light filters, ABL (automatic brightness limiter) or any post-processing features that can alter color or gamma.
  
> [!WARNING]
> If you can't meet these requirements, please avoid performing this validation since you cannot reliably validate the results. If you still wish to provide opinions on the results, be sure to provide full context to avoid misleading conclusions.

# Colorspace conversion Math

## Calculate RGB => CIE XYZ conversion matrix

Given the chromaticity coordinates of an RGB system $`(x_{r}, y_{r})`$ , $`(x_{g}, y_{g})`$ and $`(x_{b}, y_{b})`$ using the CIE xyY colorspace and its reference white $`(X_{w}, Y_{w}, Z_{w})`$ using the CIE XYZ colorspace, here is the method to compute the 3 × 3 matrix for converting RGB to CIE XYZ:

$`
\begin{equation}
    \begin{bmatrix}
        X \\ Y \\ Z
    \end{bmatrix}
    =
    \begin{bmatrix}
        M
    \end{bmatrix}
    \begin{bmatrix}
        R \\ G \\ B
    \end{bmatrix}
\end{equation}
`$

where $`M`$ is

$`
\begin{equation}
    \begin{bmatrix}
        M
    \end{bmatrix}
    =
    \begin{bmatrix}
        S_{r}X_{r} & S_{g}X_{g} & S_{b}X_{b} \\
        S_{r}Y_{r} & S_{g}Y_{g} & S_{b}Y_{b} \\
        S_{r}Z_{r} & S_{g}Z_{g} & S_{b}Z_{b} \\
    \end{bmatrix}
\end{equation}
`$

the scaling factors $`(S_{r}, S_{g}, S_{b})`$ are

$`
\begin{equation}
    \begin{bmatrix}
        S_{r} \\ S_{g} \\ S_{b}
    \end{bmatrix}
    =
    \begin{bmatrix}
        X_{r} & X_{g} & X_{b} \\
        Y_{r} & Y_{g} & Y_{b} \\
        Z_{r} & Z_{g} & Z_{b} \\
    \end{bmatrix}
    ^{-1}
    \begin{bmatrix}
        X_{w} \\ Y_{w} \\ Z_{w}
    \end{bmatrix}
\end{equation}
`$

and XYZ values are

$`
\begin{align}
    & X_{r} = \frac{x_{r}}{y_{r}} &
    & Y_{r} = 1 &
    & Z_{r} = \frac{1-x_{r}-y_{r}}{y_{r}}
\end{align}
`$

$`
\begin{align}
    & X_{g} = \frac{x_{g}}{y_{g}} &
    & Y_{g} = 1 &
    & Z_{g} = \frac{1-x_{g}-y_{g}}{y_{g}}
\end{align}
`$

$`
\begin{align}
    & X_{b} = \frac{x_{b}}{y_{b}} &
    & Y_{b} = 1 &
    & Z_{b} = \frac{1-x_{b}-y_{b}}{y_{b}}
\end{align}
`$

$`
\begin{align}
    & X_{w} = \frac{x_{w}}{y_{w}} &
    & Y_{w} = 1 &
    & Z_{w} = \frac{1-x_{w}-y_{w}}{y_{w}}
\end{align}
`$

> [!NOTE]
> Given CIE xyY coordinates, CIE XYZ coordinates are:
> 
> $` X = \frac{x}{y}Y `$
> 
> $` Z = \frac{1-x-y}{y}Y `$

## Calculate the Chromatic Adaptation Transform (CAT) Matrix

When performing a conversion between two colorspaces with a different white point, a chromatic adaptation must also be applied.

To perform a chromatic adaptation you must use the following equation:

$`
\begin{equation}
    \begin{bmatrix}
        X_{D} \\ Y_{D} \\ Z_{D}
    \end{bmatrix}
    =
    \begin{bmatrix}
        M_{CAM}
    \end{bmatrix}
    \begin{bmatrix}
        X_{S} \\ Y_{S} \\ Z_{S}
    \end{bmatrix}
\end{equation}
`$

$`
\begin{equation}
    \begin{bmatrix}
        M_{CAM}
    \end{bmatrix}
    =
    \begin{bmatrix}
        M_{CAT}
    \end{bmatrix}^{-1}
    \begin{bmatrix}
        L_{WD} / L_{WS} & 0 & 0 \\
        0 & M_{WD} / M_{WS} & 0 \\
        0 & 0 & S_{WD} / S_{WS} \\
    \end{bmatrix}
    \begin{bmatrix}
        M_{CAT}
    \end{bmatrix}
\end{equation}
`$

$`
\begin{equation}
    \begin{bmatrix}
        L_{WS} \\ M_{WS} \\ S_{WS}
    \end{bmatrix}
    =
    \begin{bmatrix}
        M_{CAT}
    \end{bmatrix}
    \begin{bmatrix}
        X_{WS} \\ Y_{WS} \\ Z_{WS}
    \end{bmatrix}
\end{equation}
`$

$`
\begin{equation}
    \begin{bmatrix}
        L_{WD} \\ M_{WD} \\ S_{WD}
    \end{bmatrix}
    =
    \begin{bmatrix}
        M_{CAT}
    \end{bmatrix}
    \begin{bmatrix}
        X_{WD} \\ Y_{WD} \\ Z_{WD}
    \end{bmatrix}
\end{equation}
`$

You can choose among several chromatic adaptation transforms. The most common are: Von Kries, Bradford, CIECAT02 and CIECAT16.



#### Von Kries matrix (not recommended)
$`
\begin{equation}
    \begin{bmatrix}
        M_{VK}
    \end{bmatrix}
    =
    \begin{bmatrix}
         0.40024 &  0.70760 & -0.08081 \\
        -0.22630 &  1.16532 &  0.04570 \\
         0.00000 & 0.00000 &  0.91822 \\
    \end{bmatrix}
\end{equation}
`$

#### Bradford matrix
$`
\begin{equation}
    \begin{bmatrix}
        M_{BF}
    \end{bmatrix}
    =
    \begin{bmatrix}
         0.8951 &  0.2664 & -0.1614 \\
        -0.7502 &  1.7135 &  0.0367 \\
         0.0389 & -0.0685 &  1.0296 \\
    \end{bmatrix}
\end{equation}
`$

#### CIECAT02 matrix (*)

$`
\begin{equation}
    \begin{bmatrix}
        M_{CAT02}
    \end{bmatrix}
    =
    \begin{bmatrix}
         0.7328 & 0.4296 & -0.1624 \\
        -0.7036 & 1.6975 &  0.0061 \\
         0.0030 & 0.0136 &  0.9834 \\
    \end{bmatrix}
\end{equation}
`$

#### CIECAT16 matrix (*)

$`
\begin{equation}
    \begin{bmatrix}
        M_{CAT16}
    \end{bmatrix}
    =
    \begin{bmatrix}
         0.401288 & 0.650173 & -0.051461 \\
        -0.250268 & 1.204414 &  0.045854 \\
        -0.002079 & 0.048952 &  0.953127 \\
    \end{bmatrix}
\end{equation}
`$

> [!WARNING]
> (*) CIECAT02 and its revision CIECAT16 should provide higher accuracy than the Bradford matrix, however they likely involve more complex operations than a simple 3×3 matrix multiplication as can be seen here: https://en.wikipedia.org/wiki/CIECAM02.
> Since there are few publicly available resources to support precise calculations with these models, the Bradford matrix will be used to minimize the risk of errors.


# Retroarch Shaders

In the `handheld` folder, you’ll find the measured consoles and their corresponding RetroArch shaders.

> [!NOTE]
> Currently, only the sRGB color space is supported. I haven’t found a way to instruct RetroArch or the operating system (at least on macOS) to interpret the shader’s output framebuffer as a non‑sRGB color space (such as Display P3, Rec. 2020, etc.). Given this limitation, there’s little benefit in supporting other color spaces, since you wouldn’t get the expected colors. If you know of any way (even a partial workaround) to overcome this limitation, I’d appreciate your support.

> [!NOTE]
> Some consoles has two shader variants: with and without a CLUT (Color Look-Up Table). Currently, both variants are identical, but I plan to improve the CLUT version by computing out-of-gamut colors to match the closest perceptually equivalent color in the target color space, rather than simply hard-clipping the RGB values.

## Shader parameters

> [!NOTE]
> Only available in the non‑LUT shader version.

### Chromatic Adaptation

Every shader includes a `Chromatic Adaptation` option. Depending on how you set it, you will get different results:

- **OFF**: Enables “**absolute color accuracy**”, meaning colors match the console’s screen exactly (except for out-of-gamut colors). Use this setting for side-by-side comparisons between your display and the console’s screen.

- **ON**: Enables “**perceptual color accuracy**”, which models the eye’s chromatic adaptation (the brain’s way of interpreting the same colors under different illuminants). This is the default option because it:
   - Removes screen tinting by using the D65 illuminant, helping mitigate the “screen lottery” where different panels have slight color variations.
   - Reduces out-of-gamut colors, lowering Delta E.


#### Example

Chromatic adaptation on the GameBoy Micro shader (**OFF** = "blue tinted / cool temperature greyscale", **ON** = "neutral greyscale")

<img width="592" height="500" alt="chromatic adaptation" src="https://github.com/user-attachments/assets/4a452df8-e732-4c4f-9de6-2d2bd965f2a6" />

## Debug Shader parameters

> [!NOTE]
> Only available in the non‑LUT shader version.

These parameters are used to analyze the shader's output image.

### Show out of Gamut colours

Enable this option to highlight in red the colors that cannot be represented in the sRGB color space. These colors are only approximations.

# External links
1. https://www.audioholics.com/news/nintendo-ds-price-fixing
2. https://www.wired.com/2008/02/sharp-hitachi-s
3. https://www.youtube.com/@hdtvtest channel
4. CIELUV: https://en.wikipedia.org/wiki/CIELUV
5. LMS colorspace and chromatic adaptation matrices (i.e. Bradford, CIECAT02, CIECAT16):
    - https://en.wikipedia.org/wiki/LMS_color_space
    - https://en.wikipedia.org/wiki/CIECAM02
6. Colorspace conversions: http://brucelindbloom.com/index.html

  
