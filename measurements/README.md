> [!WARNING]
> Some parts of this guide has been developed with AI assistance. If you find any issues or misleading info feel free to contribute.

# Displays types

- `Emissive`: the display **emits its own light** (no external illumination needed).
- `Reflective`: the display **does not emit light**; it reflects ambient light. Pixels modulate reflection, rather than emitting light.
- `Transflective`: **hybrid** of emissive and reflective. A backlight is present, but the display can also use ambient light (via a partially reflective layer).

## Known Handhelds display type

> [!NOTE]
> The following lists are not exhaustive.

- `Emissive`: `NDS Lite`, `NDSi (XL)`, `2DS (XL)`, `3DS (XL)`, `New 2DS (XL)`, `New 3DS (XL)`
- `Reflective`: TODO
- `Transflective`: TODO

## Measurements tools

Depending on the display type, you must use the appropriate meter to ensure accurate measurements. Here is a summary table:

| Meter  | Emissive | Reflective | Transflective |
| ------------- | :-------------: | :-------------: | :-------------: | 
| Colorimeter        | ✅ good accuracy | ❓ | ❓ |
| Spectroradiometer  | ✅ highest accuracy | ❓ | ❓ |
| Spectrophotometer  | ⚠️ not recommended (*) | ✅ | ❓ |

(*) A spectrophotometer primarily measures reflected light from surfaces. Some models have an “emissive mode,” but they’re generally slower, less sensitive at low light, and not ideal for bright HDR peaks or very dark near-black, common in emissive displays.

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

## Measurements guide for emissive displays

### Environment setup

To achieve reproducible and accurate measurements, you must:

* **Let the screen warm up**:
  * Warming can take 5–10 minutes, or up to 30 minutes depending on the screen type.
  * Measuring too early can cause non-reproducible results and does not reflect the true visual experience.
  * Wait until luminance and chromaticity stabilize and record when stable.
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
  * Include additional fine measurements near **white (96–99%)** and **black (1–4%)** levels, as these regions are the most prone to errors.
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

RGB gamma curves (10%-90%) + near black & near white gamma:
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

# **Measurements Validation**

To validate the results of a colorspace conversion:

1. **Calibrate your display**
   * Ensure your display supports the target gamut.
   * Use a hardware colorimeter or spectroradiometer to calibrate your display to the target colorspace (e.g., sRGB, DisplayP3 (sRGB EOTF), P3-D65 (PQ EOTF), Rec. 2020). Ensure you use a colorimeter or spectroradiometer capable of accurately measuring wide-gamut colorspaces, as not all devices support them correctly.
   * If hardware calibration is not possible, use a high-quality display with verified calibration, but note that results may have small deviations.
3. **Disable all display enhancements**
   * Turn off dynamic contrast, local dimming, HDR, blue-light filters, ABL (automatic brightness limiter) or any post-processing features that can alter color or gamma.
  
> [!WARNING]
> If you can't meet these requirements, please avoid performing this validation since you cannot reliably validate the results. If you still wish to provide opinions on the results, be sure to provide full context to avoid misleading conclusions.


# External links
1. https://www.audioholics.com/news/nintendo-ds-price-fixing
2. https://www.wired.com/2008/02/sharp-hitachi-s
3. https://www.youtube.com/@hdtvtest channel

  
