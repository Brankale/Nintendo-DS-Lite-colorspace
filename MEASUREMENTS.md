## General Info

- `author`: your name
- `date`: the date of the measurement
- `meter`: name of the meter used
- `meter type`: [colorimeter, spectroradiometer, spectrophotometer]

## Display type
- `emissive`: the screen directly generates the light needed to form the image.
- `reflective`: the screen does not emit its own light, but uses reflected ambient light.
- `quantization`: does the screen present quantization? How many bits per color? (e.g. NDS Lite has 6 bit per channel => ~262 colors)

> [!WARNING]
> This two types of display require different type of measurements.

## Emissive display: what to measure

In order to replicate the screen colorspace the following data must measured:
- chromaticity coordinates of the three primaries (R, G, B)
- chromaticity coordinate of the white point (W)
- gamma curve of three channels (R, G, B)
- maximum luminance of display (W)

In order to preserve all the possible info, both top and bottom screen must be measured if present (e.g. NDS consoles). In some cases the top and bottom displays are the same (e.g. NDS Lite), the only difference is the touch screen layer which tends to degrade the image quality. If you don't want to measure all the screens prefer the one without the touch screen which provides the best image quality. 

## Emissive display: measurement methodology

In order to achieve reproducible and accurate measurements you must:
- wait at least 30 minutes with the screen turned on before measuring to let the screen to warm-up.
- when measuring a color prefer displaying a full screen color patch on screen to avoid other color interference.
- if you are using a colorimeter, the meter must be in contact with the screen to avoid light leakage or external lights infiltrations.
- the display must be set to the maximum screen luminance possible. On some consoles (e.g. PSP) you need to plug the charger in to achieve the maximum possible luminance.
- external light sources can alter the results. To avoid this you must be in perfectly dark environment (no sunlight, no light bulb turned on, pc screen turned off). If there are multiple screens to measure (e.g. NDS) try to cover the display you are not measuring.

## Emissive display: Validating the measurements

In order to validate the results you must:
- calibrate your display. If not possible use a display known to have a good default factory calibration. Any kind of display which doesn't fit this requirement (a lot of displays unfortunately) should not be used to make judgements or adujstments on the measurements.
- the monitor should have all the image post processing effect settings turned off (e.g. dynamic contrast). These can alter the colors depending on the image displayed on screen.

  
