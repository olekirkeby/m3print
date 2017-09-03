function m3print(x, timestart, plotstart, plotend)

# x - matrix created by importcsv.matrix
# timestart - the time of the first beat of the first bar in quaternotes
# plotstart - the time of the beginning of the plot in quaternotes
# plotend   - the time of the end of the plot in quaternotes

x = double(x);
plotstart = plotstart + timestart;
plotend   = plotend   + timestart;

HEADER  = 0;
NOTEON  = 1;
NOTEOFF = 2;
TIMESIGNATURE = 3;

MINNOTE      = 40;
MINSTAFFLINE = 40;
MAXSTAFFLINE = 76;
LINEWIDTH    = 1.5;
MARKERSIZE   = 10;

n = find(x(3,:) == HEADER); #only one hit
TICKSPERQUARTERNOTE = x(2,n);

x(2,:) = x(2,:) / TICKSPERQUARTERNOTE; #convert times from ticks to quaternotes

#calculate barlines
ntimesig = find(x(3,:) == TIMESIGNATURE);
for nn = 1:length(ntimesig)
    timesignature_time(nn)  = x(2,ntimesig(nn));
    timesignature_num(nn)   = x(4,ntimesig(nn));
    timesignature_denom(nn) = x(5,ntimesig(nn));
endfor

if (length(ntimesig) == 0)
    printf('No time signature in csv file!');
    exit (1);
endif

if (length(ntimesig) == 1)
    barlines = timestart:4 * (timesignature_num(1) / timesignature_denom(1)):plotend;
else
    barlines = [timestart:4 * (timesignature_num(1) / timesignature_denom(1)):timesignature_time(2)];
    for nn = 3:length(ntimesig)
        barlines = [barlines timesignature_time(nn-1):4 * (timesignature_num(nn-1) / timesignature_denom(nn-1)):timesignature_time(nn)];
    endfor
    barlines     = [barlines timesignature_time(nn)  :4 * (timesignature_num(nn)   / timesignature_denom(nn))  :plotend];
endif

barlines = unique(barlines);
barlines = barlines(find(barlines >= plotstart & barlines <= plotend));

noteon  = find(x(3,:) == NOTEON  & x(2,:) >= plotstart & x(2,:) <= plotend);
noteoff = find(x(3,:) == NOTEOFF & x(2,:) >= plotstart & x(2,:) <= plotend);

# *********************** PLOTTING **********************************
n0 = noteon(find(mod(x(5,noteon),4) == 0));
n1 = noteon(find(mod(x(5,noteon),4) == 1));
n2 = noteon(find(mod(x(5,noteon),4) == 2));
n3 = noteon(find(mod(x(5,noteon),4) == 3));

# Plot limits
y0 = MINSTAFFLINE;
y1 = MAXSTAFFLINE; #FIXME: allow notes above top staffline

# Plot note onsets
plot(x(2,n0), x(5,n0),'ok','markersize', MARKERSIZE,   'markerfacecolor','k');
grid off;
box off;
hold on;
plot(x(2,n1), x(5,n1),'vg','markersize', MARKERSIZE  , 'markerfacecolor','g');
plot(x(2,n2), x(5,n2),'sk','markersize', MARKERSIZE-2, 'markerfacecolor','k');
plot(x(2,n3), x(5,n3),'^r','markersize', MARKERSIZE  , 'markerfacecolor','r');

# Short vertical markers
for n = 1:length(noteon)
    xv = x(2,noteon(n));
    plot([xv,xv],[MINSTAFFLINE + 12 - 1/2,MINSTAFFLINE + 12 + 1/2],'-k');
    plot([xv,xv],[MINSTAFFLINE + 24 - 1/2,MINSTAFFLINE + 24 + 1/2],'-k');
endfor

# Plot duration lines
onsets = -1 * ones(1,128);
noteonoff = sort(union(noteon, noteoff));
for n = 1:length(noteonoff)
    nn = noteonoff(n);
    if (x(3,nn) == NOTEON)
        onsets(x(5,nn)) = x(2,nn);
    elseif (onsets(x(5,nn)) >= 0)
            plot([onsets(x(5,nn)),x(2,nn)],...
                 [x(5,nn),x(5,nn)],'-k','linewidth',LINEWIDTH);
            onsets(x(5,nn)) = -1;
    else
        printf('Noteoff without matching Noteon %d, time %d\n', x(5,nn),x(2,nn));
    endif
endfor

axis([plotstart plotend y0 y1]);
axis('tics','off');

# Vertical lines
# barlines
for n = 1:length(barlines)
    plot([barlines(n),barlines(n)],[y0,y1],'-k');
    text(barlines(n),y0-1,num2str(barlines(n),'%i'));
endfor

# gridlines
for n = plotstart:plotend
    #FIXME: don't overwrite barlines
    plot([n,n],[y0,y1],':k');
endfor

# Horizontal lines, notes E
for n = MINSTAFFLINE:12:MAXSTAFFLINE
    plot([plotstart,plotend],[n,n],'-k');
    #FIXME: magic number text offset
    text(plotstart - 0.025 * (plotend - plotstart),n,num2str(n,'%i'));
endfor

for n = MINSTAFFLINE:4:MAXSTAFFLINE
    #FIXME: don't overwrites stafflines
    plot([plotstart,plotend],[n,n],':k');
endfor

hold off;