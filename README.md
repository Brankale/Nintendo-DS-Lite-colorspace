# Nintendo-DS-Lite-colorspace

> [!IMPORTANT]
> I'm not a color expert. All information you can find here is the result of my research. Take this info with a grain of salt.
> If you notice any errors, feel free to open an issue or a PR, but don't expect any replies or fixes. This is in fact a personal project, and I work on it in my spare time.

## Display specs

- `Screen Size`: Dual 3.0 inches
- `Aspect Ratio`: 4:3
- `Resolution: Dual`: 256 x 192
- `Dots Per Inch`: 110
- `Screen Colors`: 6 bits per channel (18‑bit total, 262,144 colors)

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
> Is it fine to offset the data or is better a scaling approach? 

\- | u' | v'
--- | --- | ---
Red | 0.4104 ± 0.0004 | 0.5226 ± 0.0004
Green | 0.1374 ± 0.0004 | 0.5681 ± 0.0004
Blue| 0.1540 ± 0.0004 | 0.2118 ± 0.0004
White| 0.1995 ± 0.0004 | 0.4612 ± 0.0004



## Colorspace conversion

### 1. Calculate the RGB to CIE XYZ conversion matrix for NDS Lite colorspace

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

XYZ values are

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

and the scaling factors $`(S_{r}, S_{g}, S_{b})`$ are

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

> [!NOTE]
> Given CIELUV coordinates, CIE xyY coordinates are:
>
> $` x = \frac{9u'}{6u'-16v'+12} `$ 
> 
> $` y = \frac{4v'}{6u'-16v'+12} `$

> [!NOTE]
> Given CIE xyY coordinates, CIE XYZ coordinates are:
> 
> $` X = \frac{x}{y}Y = \frac{9u'}{4v'}Y `$
> 
> $` Z = \frac{1-x-y}{y}Y = \frac{12-3u'-20v'}{4v'}Y `$

> [!NOTE]
> $`Y_{w}`$ = screen brightness in cd/m2. When calculating CIE XYZ conversion matrix we must use a relative luminance of 1.0 instead of the absolute screen luminance (i.e. 200 cd/m2).

#### Result

Using a relative luminance $`Y_{w} = 1`$ the RGB to CIE XYZ matrix is:

$`
\begin{equation}
    \begin{bmatrix}
        M
    \end{bmatrix}
    =
    \begin{bmatrix}
        0.42210 & 0.34542 & 0.20576 \\
        0.23889 & 0.63475 & 0.12637 \\
        0.03620 & 0.06307 & 1.08107 \\
    \end{bmatrix}
\end{equation}
`$

### 2. Calculate the Chromatic Adaptation Matrix

When performing a conversion between colorspaces with different white points a chromatic adaptation must also be applied.

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

You can choose among several chromatic adaptation transforms (CATs) such as: Von Kries, Bradford, CIECAT02 and CIECAT16. Despite being older than CIECAT02 and its revision CIECAT16, the Bradford matrix is still the industry standard, with numerous studies demonstrating its accuracy.

> [!NOTE]
> For the calculations I'll use the Bradford matrix.

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

#### Bradford matrix (recommended)
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

#### CIECAT02 matrix

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

#### CIECAT16 matrix

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


## Links
- Colorspace conversions: http://brucelindbloom.com/index.html
- Nintendo DS Lite screen info:
  - https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20250311235306/https://www.displaymate.com/psp_ds_shootout.htm
  - (archive.org): https://web.archive.org/web/20241006105435/https://www.displaymate.com/psp_ds_cie.jpg
  - (archive.org): https://web.archive.org/web/20241006174320/https://www.displaymate.com/psp_ds_gamma.jpg
- CIELUV: https://en.wikipedia.org/wiki/CIELUV
- LMS colorspace and chromatic adaptation matrices (i.e. Bradford, CIECAT02, CIECAT16):
    - https://en.wikipedia.org/wiki/LMS_color_space
    - https://en.wikipedia.org/wiki/CIECAM02
