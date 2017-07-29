function m3print(x, barstart, barend)

NOTEBARLINE       =  0;
NOTEGRIDSPACING   =  1;
DURATIONAUTOMATIC = -1;
MINNOTE      =  8;
MINSTAFFLINE =  8;
MAXSTAFFLINE = 44;
LINEWIDTH    = 1.5;
MARKERSIZE   = 10;

N = length(find(x(:,4) >= MINNOTE));
S = length(find(x(:,4) <  MINNOTE));

notebar      = zeros(N,1);
notebeat     = zeros(N,1);
noteduration = zeros(N,1);
note         = zeros(N,1);

symbolbar      = zeros(S,1);
symbolbeat     = zeros(S,1);
symbolduration = zeros(S,1);
symbolnote     = zeros(S,1);

number_of_notes   = 0;
number_of_symbols = 0;

# Parse x into notes and symbols
for n = 1:length(x)
    if (x(n,4) >= MINNOTE)
        number_of_notes = number_of_notes + 1;
        notebar(number_of_notes,1)      = x(n,1);
        notebeat(number_of_notes,1)     = x(n,2);
        noteduration(number_of_notes,1) = x(n,3);
        note(number_of_notes,1)         = x(n,4);
    else
        number_of_symbols = number_of_symbols + 1;
        symbolbar(number_of_symbols,1)      = x(n,1);
        symbolbeat(number_of_symbols,1)     = x(n,2);
        symbolduration(number_of_symbols,1) = x(n,3);
        symbol(number_of_symbols,1)         = x(n,4);
    endif
endfor

if (N == 0) # FIXME: check should include symbols
    disp('Input must contain at least one note');
    return;
endif

grids = find(symbol == NOTEGRIDSPACING);
for n = 1:number_of_symbols
    if (NOTEBARLINE == symbol(n))
        barx = [0:symbolduration(n):ceil(notebar(end) * symbolduration(n)
                                       + notebeat(end) - 1
                                       + noteduration(end))];
    endif
    # FIXME: handle varying bar durations

    if (NOTEGRIDSPACING == symbol(n))
        griddx = symbolduration(n);
    endif
    # FIXME: handle varying gridlines
endfor


notex = note; #allocate memory
for n = 1:N
    if (notebar(n) < 1)
        notex(n) = -1; #FIXME: pickup bar
    else
        notex(n) = barx(notebar(n)) + notebeat(n) - 1;
    endif
endfor

# Calculate durations until next note
[sortnotex, notexi] = sort(notex);
diffsortnotex = diff(sortnotex);
diffsortnotex(end + 1) = 0;
for n = (N-1):-1:1
    if (diffsortnotex(n) == 0)
        diffsortnotex(n) = diffsortnotex(n+1);
    endif
endfor
notexduration = diffsortnotex(notexi);

# *********************** PLOTTING **********************************
nx = intersect(find(notebar   >= barstart),find(notebar   <  barend));
bx = intersect(find(symbolbar >= barstart),find(symbolbar <= barend));

n0 = nx(find(mod(note(nx),4) == 0)); x0 = notex(n0);
n1 = nx(find(mod(note(nx),4) == 1)); x1 = notex(n1);
n2 = nx(find(mod(note(nx),4) == 2)); x2 = notex(n2);
n3 = nx(find(mod(note(nx),4) == 3)); x3 = notex(n3);

# Plot limits
px0 = barx(barstart);
px1 = barx(barend);
py0 = MINSTAFFLINE;
py1 = max([ceil(max(note)),MAXSTAFFLINE]);

# Plot note onsets
plot(x0, note(n0),'ok','markersize', MARKERSIZE,   'markerfacecolor','k');
grid off;
box off;
hold on;
plot(x1, note(n1),'vg','markersize', MARKERSIZE  , 'markerfacecolor','g');
plot(x2, note(n2),'sk','markersize', MARKERSIZE-2, 'markerfacecolor',[1 0.7 0]);
plot(x3, note(n3),'^r','markersize', MARKERSIZE  , 'markerfacecolor','r');

for n = 1:length(nx)
# Duration lines
    nxn = nx(n);
    if (noteduration(nxn) > 0)
        plot(notex(nxn) + [0,noteduration(nxn)],
            [note(nxn),note(nxn)],'-k','linewidth',LINEWIDTH);
    elseif (noteduration(nxn) == DURATIONAUTOMATIC)
        # plot duration line until next note
        plot(notex(nxn) + [0,notexduration(nxn)],
            [note(nxn),note(nxn)],'-k','linewidth',LINEWIDTH);
    endif
# Short vertical markers
    plot([notex(nxn),notex(nxn)],[20-1/2,20+1/2],'-k');
    plot([notex(nxn),notex(nxn)],[32-1/2,32+1/2],'-k');
endfor

axis([px0 px1 py0 py1]);
axis('tics','off');

# Vertical lines
for n = barstart:barend
    # barlines
    plot([barx(n),barx(n)],[py0,py1],'-k');
    text(barx(n),py0-1,num2str(n,'%i'));
    # gridlines
    gridlinex = barx(n) + griddx;
    if (n < barend)
        while (gridlinex < barx(n+1))
           plot(gridlinex + [0,0],[py0,py1],':k');
           gridlinex = gridlinex + griddx;
        endwhile
    endif
endfor

# Horizontal lines, notes E
for n = MINSTAFFLINE:12:MAXSTAFFLINE
    plot([px0,px1],[n,n],'-k');
    text(px0-1,n,num2str(n,'%i'));
endfor

hold off;