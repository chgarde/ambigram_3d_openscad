#!/bin/bash
#ffmpeg -framerate 30 -pattern_type glob -i 'frames/*.png' -c:v libx264 -pix_fmt yuv420p video.mp4
ffmpeg -framerate 30 -pattern_type glob -i 'frames/*.png' -vf palettegen palette.png
ffmpeg -framerate 30 -pattern_type glob -i 'frames/*.png' -i palette.png -filter_complex paletteuse -r 10 -loop 0 video.gif
