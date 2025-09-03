## General Info

- `author`: the author name of the measurements.
- `date`: the date of the measurement. This is important because screen colors tends to degrade over time and with use. Knowing the time a measurement was taken can help ensure the accuracy of the measurements.
- `meter`: name of the meter used.
- `meter type`: [colorimeter, spectroradiometer, spectrophotometer].
- `console`: the console measured.
- `measured screen manufacturer`: the manufacturer of the measured screen.
- `measurement software`: the name of the software used to make the measurements.
- `measurement software version`: the version of the software used to make the measurements.
- `quantization`: does the screen present quantization? How many bits per color? (e.g. NDS Lite has 6 bit per channel => ~262K colors)


# Displays types

- `Emissive`: the display **emits its own light** (no external illumination needed).
- `Reflective`: the display **does not emit light**; it reflects ambient light. Pixels modulate reflection rather than emitting.
- `Transflective`: **hybrid** of emissive and reflective. A backlight is present, but the display can also use ambient light (via a partially reflective layer).

## Handhelds display type

- `Emissive`: `GBA SP`, `NDS Phat`, `NDS Lite`, `NDSi (XL)`, `2DS (XL)`, `3DS (XL)`, `New 2DS (XL)`, `New 3DS (XL)`
- `Reflective`: TODO
- `Transflective`: `GBA` (to verify)

## Measurements tools

Depending on the display type, you must use the appropriate meters to get proper and accurate measurements. Below there is a summary table of the tools you can use depending on the use-case:

| Meter  | Emissive | Reflective | Transflective |
| ------------- | :-------------: | :-------------: | :-------------: |
| Colorimeter        | ✅  | ❓  | ❓ |
| Spectroradiometer  | ✅  | ❓  | ❓ |
| Spectrophotometer  | ❌  | ✅  | ❓ |

> [!NOTE]
> Spectroradiometer provides better measurements compared to a colorimeter.

# Do the measurements

## Introduction

Handheld LCD screen present a lot of challanges:
- color variations depending on the **viewing angle** (especially on TN panels).
- different **color tint** caused by the so-called ‘screen lottery’ phenomenon in certain handhelds (e.g. the 3DS), where manufacturing tolerances cause units with the same nominal display model to exhibit distinct color characteristics.
- different **screen manufacturers**: some handhelds have different screen manufacturers (e.g. NDS Lite has LCD screens coming from Hitachi and Sharp (1)(2)) which can cause color variations across different units of the same handheld. 
- **screen protectors and touchscreens** (or screen digitizers) can affect color accuracy, especially if they are old and have been exposed to sunlight, which can degrade the plastic and cause a yellowish tint.

The goal is to **measure the best possible scenario**, removing all the factors which can degrade image quality.

## Measurements guide for emissive displays

### Environment setup

To achieve reproducible and accurate measurements, you must:

* **Let the screen warm up**:
  * Warming can take 5–10 minutes, or up to 30 minutes depending on the screen type.
  * Measuring too early can produce non-reproducible results and does not reflect the true visual experience.
  * Begin measurements only once values have stabilized.
* **Remove external light sources**:
  * Avoid sunlight, lamps, or other screens that can affect measurements.
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


### What to measure

> [!IMPORTANT]
> If the screen is not original any kind of measurements are invalid.

In order to replicate the screen colorspace the following data must be measured:
- chromaticity coordinates of the three primaries (R, G, B)
- chromaticity coordinate of the white point (W)
- gamma curve of the three channels (R, G, B)
- maximum luminance of display (White)
- minimum luminance of the display (Black)

In order to preserve all the possible info, both top and bottom screen must be measured if present (e.g. NDS consoles). In some cases the top and bottom displays are the same (e.g. NDS Lite), the only difference is the touch screen layer which tends to degrade the image quality. If you don't want to measure all the screens prefer the one without the touch screen which provides the best image quality. 

# **Measurements Validation**

To validate the results of a colorspace conversion:

1. **Calibrate your display**
   * Use a hardware colorimeter or spectroradiometer to calibrate your display to the target colorspace (e.g., sRGB, DisplayP3 (P3 D65), Rec. 2020). Ensure you use a colorimeter or spectroradiometer capable of accurately measuring wide-gamut colorspaces, as not all devices support them correctly.
   * If hardware calibration is not possible, use a high-quality display with verified calibration, but note that results may have small deviations.
2. **Disable all display enhancements**
   * Turn off dynamic contrast, local dimming, HDR, blue-light filters, ABL (automatic brightness limiter) or any post-processing features that can alter color or gamma.
  
> [!WARNING]
> If you can't meet these requirements, please avoid performing this validation since you cannot reliably validate the results. If you still wish to provide opinions on the results be sure to give all the context to avoid misleading info.


# External links

1. https://www.audioholics.com/news/nintendo-ds-price-fixing
2. https://www.wired.com/2008/02/sharp-hitachi-s

  
