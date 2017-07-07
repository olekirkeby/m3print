# m3print
Music notation using Octave

The title m3print is a short name for the combination of the two terms Major Thirds and Piano Roll Inspired NoTation. It is an alternative to traditional music notation, and it is essentially an extension of the piano roll notation that is commonly used for MIDI editing in music recording software products.  

The system uses Octave (an open-source Matlab clone). In order to try it, start Octave from the directory you have cloned this repository into, then enter the two commands  

x = importcsv('birdland.csv'); m3print(x);
