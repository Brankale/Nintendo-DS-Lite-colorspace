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


## Display type
- `Emissive`: the display **emits its own light** (no external illumination needed).
- `Reflective`: the display **does not emit light**; it reflects ambient light. Pixels modulate reflection rather than emitting.
- `Transflective`: **hybrid** of emissive and reflective. A backlight is present, but the display can also use ambient light (via a partially reflective layer).

> [!WARNING]
> Every display type require different measurements methodologies to get accurate results.

### Handhelds display type

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
- color variations depending on the viewing angle (especially on TN panels)
- different color tint caused by the so-called ‘screen lottery’ phenomenon in certain handhelds (e.g. the 3DS), where manufacturing tolerances cause units with the same nominal display model to exhibit distinct color characteristics.
- different screen manufacturers: some handhelds have different screen manufacturers (e.g. NDS Lite has LCD screens coming from Hitachi and Sharp (1)(2)) which can cause color variations across different units of the same handheld. 
- screen protectors and touchscreens (or screen digitizers) can affect color accuracy, especially if they are old and have been exposed to sunlight, which can degrade the plastic and cause a yellowish tint.

The goal is to measure the best possible scenario, removing all the factors which can degrade image quality.

## Emissive display measurements guide

### Environment setup

In order to achieve reproducible and accurate measurements you must:
- Let the screen warm-up. This can take from 5 to 10 minutes, up to 30 minutes depending on the screen type. Doing measurements too early can results in non-reproducible measurements and does not provide the actual screen visual experience. In general, start measuring only when measurements are stable.
- Remove any kind of external light source which can alter the measurements (e.g. no sunlight, no light bulb turned on, pc screen turned off). If there are multiple screens to measure (e.g. NDS family) cover the display you are not measuring to avoid light leakage.
- Some handhelds (e.g. PSP-1000) requires the charger to be plugged-in to reach the maximum screen luminance.
- use full-screen color patches. This requires either homebrew software on a modded handheld, hardware modifications, or the use of special cartridges.
- (optional, but appreciated) remove screen protectors and screen digitizer (i.e. touchscreen). These are unnecessary "screen layers" that can alter the measurements.
- (TODO: to revise) if you are using a colorimeter, the meter must be in contact with the screen to avoid light leakage or external lights infiltrations.

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

# Measurements validation

In order to validate the results you must:
- calibrate your display. If not possible use a display known to have a good default factory calibration. Any kind of display which doesn't fit this requirement (a lot of displays unfortunately) should not be used to make judgements or adjustments on the measurements.
- disable all the monitor image post processing settings (e.g. dynamic contrast). These can alter the colors.

# External links

1. https://www.audioholics.com/news/nintendo-ds-price-fixing
2. https://www.wired.com/2008/02/sharp-hitachi-s

  
