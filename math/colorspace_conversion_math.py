import numpy as np
import colour

# CIE xyY coordinates of the target display for which you want to reproduce colors.
TARGET_R_CHROMATICITY = np.array([0.5842, 0.3446])    # R primary (x, y)
TARGET_G_CHROMATICITY = np.array([0.3223, 0.6114])    # G primary (x, y)
TARGET_B_CHROMATICITY = np.array([0.1461, 0.0691])    # B primary (x, y)
TARGET_W_CHROMATICITY = np.array([0.2804, 0.2754])    # W primary (x, y)

# CIE xyY coordinates of the destination colorspace white point
DEST_W_CHROMATICITY = colour.CCS_ILLUMINANTS['CIE 1931 2 Degree Standard Observer']['D65']

if __name__ == "__main__":
    target_colourspace = colour.RGB_Colourspace(
        name = 'Target Display',
        primaries = np.array([
            TARGET_R_CHROMATICITY,
            TARGET_G_CHROMATICITY,
            TARGET_B_CHROMATICITY
        ]),
        whitepoint = TARGET_W_CHROMATICITY
    )

    print("RGB -> XYZ matrix:")
    print(target_colourspace.matrix_RGB_to_XYZ)

    cat_mtx = colour.adaptation.matrix_chromatic_adaptation_VonKries(
        XYZ_w = colour.xy_to_XYZ(DEST_W_CHROMATICITY),
        XYZ_wr = colour.xy_to_XYZ(TARGET_W_CHROMATICITY),
        transform = "Bradford"
    )
    print("\nChromatic Adaptation Transform Matrix (Bradford):")
    print(cat_mtx)
