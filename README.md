figgsAS3
========

Latest Flash file available at:
https://github.com/fergbyrne/figgsAS3/raw/master/bin-debug/FBCLA.swf

Implementation in ActionScript of a prototype Cortical Learning Algorithm region. See Numenta.org for more info.

The current iteration uses the mouse X position as the input data stream, and uses the 28/128 bit fixed width sliding bucket as per Numenta's standard scalar encoder. You can see the encoded bitmask at the top of the screen.

All the settings can be adjusted in cla.Region

Current Behaviour:

- User provides the data by moving the mouse around
- Easy to understand feedback showing input bit vector (top of screen)
- Active columns (top 2% max) displayed in response, colour of "base" circles deepens for more active
- Smoothly varying SDR already showing up, activation pattern is quite stable

TODO

- Get more columns active 
- Add learning of "good connections" for spatial pooler
- All the rest of the CLA!!





