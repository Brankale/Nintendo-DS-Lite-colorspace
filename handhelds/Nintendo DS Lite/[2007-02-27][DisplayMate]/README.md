## Display specs

- `Screen Size`: 3.0 inches (7.62 cm diagonal)
- `Aspect Ratio`: 4:3
- `Resolution: Dual`: 256 x 192
- `Dots pitch`: 0.24 mm
- `PPI`: 106.67
- `Screen Colors`: 6 bits per channel (18‑bit total, 262,144 colors)

## Measurements

- `author`: DisplayMate Technologies Corporation
- `meter`: Konica Minolta CS-200
- `meter type`: spectroradiometer
- `methodology`: https://web.archive.org/web/20241102042303/https://www.displaymate.com/mobile_testing.htm


\- | Bottom screen (touchscreen) | Top screen
--- | --- | ---
Peak Brightness | 190 cd/m2 | 200 cd/m2
Black Level Brightness | 0.32 cd/m2 | 0.31 cd/m2
Contrast Ratio(*) (for Low Ambient Light) | 594 | 645
Screen Reflectance | 21% | 15%
Contrast Ratio (for High Ambient Light) | 9 | 13
Forward Tilt Viewing (Contrast at +15°) | 96 | 109
Horizontal Side Viewing (Contrast at ±45°) | 26 | 23

> [!NOTE]
> $` \begin{equation}\text{Contrast Ratio} = \frac{\text{Peak Brightness}}{\text{Black Level Brightness}} \end{equation} `$
> 
> $` e.g. \begin{equation}\text{Contrast Ratio} = \frac{200 cd/m2}{0.31 cd/m2} = 645 \end{equation} `$

#### Greyscale Gamma

- `Compression`: 6%
- `Gamma`: 1.85

<img src="https://github.com/user-attachments/assets/01df8029-a4dd-4669-b318-11a97e5951a3" alt="Alt Text" width="300">

#### Chromaticity coordinates (CIE 1976 UCS chromaticity diagram)
<img src="https://github.com/user-attachments/assets/61194e74-fbce-4f6c-84b4-1de8ea464c8c" alt="Alt Text" width="300">

These are the raw data extracted from the chart:

\- | u' | v'
--- | --- | ---
Red | 0.410375 ± 0.0004375 | 0.523664 ± 0.0004453
Green | 0.137375 ± 0.0004375 | 0.569084 ± 0.0004453
Blue| 0.154000 ± 0.0004375 | 0.212850 ± 0.0004453
White| 0.199500 ± 0.0004375 | 0.462214 ± 0.0004453

\- | u' | v'
--- | --- | ---
sRGB white - chart raw data | 0.197750 ± 0.0004375 | 0.469338 ± 0.0004453
sRGB white - known exact value | 0.197830 | 0.468320
coordinates offset | $`u'_{offset}`$ = -0.000080 | $`v'_{offset}`$ = 0.001018

The u' coordinate's offset is lower than the absolute error (i.e. |$`u'_{offset}`$| < 0.0004375) so we can take the raw data.

The v' coordinate's offset is greater than the absolute error (i.e. |$`v'_{offset}`$| > 0.0004453) so we must apply an offset of $`-v'_{offset}`$.

> [!WARNING]
> Offsetting the $`v'_{offset}`$ is probably not the best solution and should not be considered as a best practice.

\- | u' | v'
--- | --- | ---
Red | 0.4104 ± 0.0004 | 0.5226 ± 0.0004
Green | 0.1374 ± 0.0004 | 0.5681 ± 0.0004
Blue| 0.1540 ± 0.0004 | 0.2118 ± 0.0004
White| 0.1995 ± 0.0004 | 0.4612 ± 0.0004



## Links
- Nintendo DS Lite screen info:
  - https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20250311235306/https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20241006105435/https://www.displaymate.com/psp_ds_cie.jpg
  - (archive.org): https://web.archive.org/web/20241006174320/https://www.displaymate.com/psp_ds_gamma.jpg
  - https://www.nintendo.com/en-gb/Support/Nintendo-DS-Lite/Product-Information/Technical-data/Product-Information-242119.html
