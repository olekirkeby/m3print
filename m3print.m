function m3print(x, start, end)

MARKERSIZE   = 10;
MINSTAFFLINE =  8;
MAXSTAFFLINE = 44;
LINEWIDTH    = 1.5;

[R,C] = size(x);

onsets    = x(:,1) + (x(:,2)-1)/4 #in bars
durations = x(:,3);                #in quaternotes
notes     = x(:,4);                #relative to low E = 8

notes0 = find(mod(notes,4) == 0);
notes1 = find(mod(notes,4) == 1);
notes2 = find(mod(notes,4) == 2);
notes3 = find(mod(notes,4) == 3);

# Plot limits
x0 = start;
x1 = min(ceil(max(onsets + durations/4)),end);
y0 = MINSTAFFLINE;
y1 = max([ceil(max(notes)),MAXSTAFFLINE]);

# Note onsets
plot(onsets(notes0), notes(notes0),'ok','markersize', MARKERSIZE, 'markerfacecolor','k');
grid off;
hold on;
plot(onsets(notes1), notes(notes1),'vg','markersize', MARKERSIZE  , 'markerfacecolor','g');
plot(onsets(notes2), notes(notes2),'sk','markersize', MARKERSIZE-2, 'markerfacecolor','k');
plot(onsets(notes3), notes(notes3),'^r','markersize', MARKERSIZE  , 'markerfacecolor','r');

unique_onsets = unique(onsets);;
unique_durations = [diff(unique_onsets); 0];

# Duration lines
for n = 1:R
    if (durations(n) > 0)
        plot(onsets(n)+[0,durations(n)/4],[notes(n),notes(n)],'-k','linewidth',LINEWIDTH);
    elseif (durations(n) < 0)
        # plot duration line until next note
        index = find(onsets(n) == unique_onsets) # Only one hit here
        plot(onsets(n)+[0,unique_durations(index)],[notes(n),notes(n)],'-k','linewidth',LINEWIDTH);
    endif
endfor

axis([x0 x1 y0 y1]);
axis('tics','off');
box off;

# ********* Grid *************
# Vertical lines
for n = x0:1/4:x1
    if (n - floor(n) < 0.01)
        plot([n,n],[y0,y1],'-k');
        text(n,y0-1,num2str(n,'%i'));
    elseif
        plot([n,n],[y0,y1],':k');
    endif
endfor
for n = 1:R
    plot([onsets(n),onsets(n)],[20-1/2,20+1/2],'-k');
    plot([onsets(n),onsets(n)],[32-1/2,32+1/2],'-k');
endfor 

# Horizontal lines, E
for n = MINSTAFFLINE:12:MAXSTAFFLINE
    plot([x0,x1],[n,n],'-k');
endfor

hold off;