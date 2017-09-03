function x = importcsv(file)

# track, time, command, channel, note, velocity

#FIXME: avoid copy-paste of defines
HEADER  = 0;
NOTEON  = 1;
NOTEOFF = 2;
TIMESIGNATURE = 3;

f = fopen(file);
n = 1;

do
    s = fgetl(file);

    if (findstr(s,'Tempo'))
        v = strread(s, "%d");
        printf("Tempo %d\n", 60000000 / v(4));
    endif
    if (findstr(s,'Header'))
        v = strread(s, "%d");
        x(1,n) = v(5); #number of tracks
        x(2,n) = v(6); #ticks per quarternote
        x(3,n) = HEADER;
        x(4,n) = v(4); #midiformat
        printf("Ticks per quarternote %d\n", v(6));
        n = n + 1;
    endif
    if (findstr(s,'Time_signature'))
        v = strread(s, "%d");
        x(1,n) = v(1); # track
        x(2,n) = v(2); # time
        x(3,n) = TIMESIGNATURE;
        x(4,n) = v(4); # num
        x(5,n) = 2^v(5); # denom
        printf("Time signature at %d: %d / %d\n", v(2), v(4), x(5,n));
        n = n + 1;
    endif
    if (findstr(s,'Note_on_c'))
        v = strread(s, "%d");
        x(1,n) = v(1); # track
        x(2,n) = v(2); # time
        x(3,n) = NOTEON;
        x(4,n) = v(4); # channel;
        x(5,n) = v(5); # note;
        x(6,n) = v(6); # velocity;
        n = n + 1;
    endif
    if (findstr(s,'Note_off_c'))
        v = strread(s, "%d");
        x(1,n) = v(1); # track
        x(2,n) = v(2); # time
        x(3,n) = NOTEOFF;
        x(4,n) = v(4); # channel;
        x(5,n) = v(5); # note;
        x(6,n) = 0; # velocity;
        n = n + 1;
    endif
until (findstr(s,'End_of_file'))

fclose(f);