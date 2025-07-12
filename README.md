# Nintendo-DS-Lite-colorspace

## Display specs

- `Screen Size`: Dual 3.0 inches
- `Aspect Ratio`: 4:3
- `Resolution: Dual`: 256 x 192
- `Dots Per Inch`: 110
- `Screen Colors`: ~262K (6 bit)

\- | Bottom screen (touchscreen) | Top screen
--- | --- | ---
Peak Brightness | 190 cd/m2 | 200 cd/m2
Black Level Brightness | 0.32 cd/m2 | 0.31 cd/m2
Contrast Ratio(*) (for Low Ambient Light) | 594 | 645
Screen Reflectance | 21% | 15%
Contrast Ratio (for High Ambient Light) | 9 | 13
Forward Tilt Viewing (Contrast at +15°) | 96 | 109
Horizontal Side Viewing (Contrast at ±45°) | 26 | 23

(*) Contrast Ratio = Peak Brightness / Black Level Brightness (e.g. 200 / 0.31 = 645)

#### Greyscale Gamma

- `Compression`: 6%
- `Gamma`: 1.85

<img src="https://github.com/user-attachments/assets/01df8029-a4dd-4669-b318-11a97e5951a3" alt="Alt Text" width="300">

#### Chromaticity coordinates (CIE 1976 / CIELUV diagram)
<img src="https://github.com/user-attachments/assets/61194e74-fbce-4f6c-84b4-1de8ea464c8c" alt="Alt Text" width="300">

\- | u' | v'
--- | --- | ---
Red | 0.4096 ± 0.0009 | 0.5239 ± 0.0009
Green | 0.1368 ± 0.0009 | 0.5690 ± 0.0009
Blue| 0.1535 ± 0.0009 | 0.2125 ± 0.0009
White| 0.1991 ± 0.0009 | 0.4625 ± 0.0009

> [!WARNING]
> extracted chromaticity values must be revised

CIELUV > CIE xyY > CIE XYZ

$` x = \frac{9u'}{6u'-16v'+12} `$

$` y = \frac{4v'}{6u'-16v'+12} `$

$` X = \frac{x}{y}Y = \frac{9u'}{4v'}Y `$

$` Z = \frac{1-x-y}{y}Y = \frac{12-3u'-20v'}{4v'}Y `$

\- | X | Y | Z
--- | --- | --- | ---
Red | TODO | 200 | TODO
Green | TODO | 200 | TODO
Blue| TODO | 200 | TODO
White| TODO | 200 | TODO

Y = screen brightness in cd/m2 (max NDS Lite screen brightness is 200 cd/m2)



## Links
- Colorspace conversions: http://brucelindbloom.com/index.html
- Nitendo DS Lite screen info:
  - https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20250311235306/https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20241006105435/https://www.displaymate.com/psp_ds_cie.jpg
  - (archive.org): https://web.archive.org/web/20241006174320/https://www.displaymate.com/psp_ds_gamma.jpg
- CIELUV: https://en.wikipedia.org/wiki/CIELUV
