## General Info

- `author`: your name
- `date`: the date of the measurement. This is important because screen colors tends to degrade over time and with use. Knowing the time a measurement was taken can help ensure the accuracy of the measurements.
- `meter`: name of the meter used
- `meter type`: [colorimeter, spectroradiometer, spectrophotometer]
- `console`: the console measured
- `measured screen manufacturer`: the manufacturer of the measured screen

## Display type
- `emissive`: the screen directly generates the light needed to form the image.
- `reflective`: the screen does not emit its own light, but uses reflected ambient light.
- `quantization`: does the screen present quantization? How many bits per color? (e.g. NDS Lite has 6 bit per channel => ~262K colors)

> [!WARNING]
> These two types of displays require different types of measurements.

# Emissive display (only)

## What to measure

> [!IMPORTANT]
> If the screen is not original any kind of measurements are invalid.

In order to replicate the screen colorspace the following data must measured:
- chromaticity coordinates of the three primaries (R, G, B)
- chromaticity coordinate of the white point (W)
- gamma curve of the three channels (R, G, B)
- maximum luminance of display (W)

In order to preserve all the possible info, both top and bottom screen must be measured if present (e.g. NDS consoles). In some cases the top and bottom displays are the same (e.g. NDS Lite), the only difference is the touch screen layer which tends to degrade the image quality. If you don't want to measure all the screens prefer the one without the touch screen which provides the best image quality. 

> [!WARNING]
> The same console can have different LCD manufacturers which can lead to different results (e.g. NDS Lite has LCD screens coming from Hitachi and Sharp (1)(2)). If you have multiple units of the same console with different colors this is probably one of the causes.

## Measurement methodology

In order to achieve reproducible and accurate measurements you must:
- wait at least 30 minutes with the screen turned on before measuring to let the screen to warm-up.
- when measuring a color prefer displaying a full screen color patch on screen to avoid other color interference.
- if you are using a colorimeter, the meter must be in contact with the screen to avoid light leakage or external lights infiltrations.
- the display must be set to the maximum screen luminance possible. On some consoles (e.g. PSP) you need to plug the charger in to achieve the maximum possible luminance.
- external light sources can alter the results. To avoid this you must be in perfectly dark environment (no sunlight, no light bulb turned on, pc screen turned off). If there are multiple screens to measure (e.g. NDS) try to cover the display you are not measuring.

## Measurements validation

In order to validate the results you must:
- calibrate your display. If not possible use a display known to have a good default factory calibration. Any kind of display which doesn't fit this requirement (a lot of displays unfortunately) should not be used to make judgements or adjustments on the measurements.
- the monitor should have all the image post processing effect settings turned off (e.g. dynamic contrast). These can alter the colors depending on the image displayed on screen.

> [!WARNING]
> The same console can have different LCD manufacturers which can lead to different results (e.g. NDS Lite has LCD screens coming from Hitachi and Sharp (1)(2)).

# External links

1. https://www.audioholics.com/news/nintendo-ds-price-fixing
2. https://www.wired.com/2008/02/sharp-hitachi-s

  
