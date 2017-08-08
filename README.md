# m3print
Music notation using Octave

The title m3print is a short name for the combination of the two terms Major Thirds and Piano Roll Inspired NoTation. It is an alternative to traditional music notation, and it is essentially an extension of the piano roll notation that is commonly used for MIDI editing in music recording software products.  

The system uses Octave (an open-source Matlab clone). In order to try it, start Octave from the directory you have cloned this repository into, then enter the two commands  

x = importcsv('west_coast_blues.csv'); m3print(x, start_time, end_time);

where start_time and end_time are in quaternotes. For converting from midi to csv you can use the excellent tool midicsv (http://www.fourmilab.ch/webtools/midicsv/).

The notation is interpreted as follows.

- the vertical scale is in midinotes, going from 40 (the lowest E on a guitar) to 76 (an E three octaves higher)
- the full horizontal lines are at octaves of E; the dashed lines are at major thirds (Ab and C)
- the full vertical lines indicates the beginning of a bar; the dashed vertical lines are quaternotes
- a black circle indicates one of the notes E, Ab, and C (0, 4, and 8 in clock notation)
- a black square indicates one of the notes Bb, D, and Gb (2, 6, and 10 in clock notation)
- a green triangle pointing downwards indicates one of the notes A, Db, and F (1, 5, and 9 in clock notation)
- a red triangle pointing upwards indicates one of the notes B, Eb, and G (3, 7, and 11 in clock notation)

