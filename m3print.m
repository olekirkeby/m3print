function m3print(x, start, end)

MARKERSIZE = 10;
MINSTAFFLINE =  8;
MAXSTAFFLINE = 44;

[R,C] = size(x);

onsets    = x(:,1) + (x(:,2)-1)/4; #in bars
durations = x(:,3);                #in quaternotes
notes     = x(:,4);                #relative to low E = 8

# Plot limits
x0 = start;
x1 = min(ceil(max(onsets + durations/4)),end);
y0 = MINSTAFFLINE;
y1 = max([ceil(max(notes)),MAXSTAFFLINE]);

n0 = find(mod(notes,4) == 0);
n1 = find(mod(notes,4) == 1);
n2 = find(mod(notes,4) == 2);
n3 = find(mod(notes,4) == 3);

# Note onsets
plot(onsets(n0), notes(n0),'ok','markersize', MARKERSIZE, 'markerfacecolor','k');
grid off;
hold on;
plot(onsets(n1), notes(n1),'vg','markersize', MARKERSIZE  , 'markerfacecolor','g');
plot(onsets(n2), notes(n2),'sk','markersize', MARKERSIZE-2, 'markerfacecolor','k');
plot(onsets(n3), notes(n3),'^r','markersize', MARKERSIZE  , 'markerfacecolor','r');

# Duration lines
for n = 1:R
    if (durations(n) > 0)
        plot(onsets(n)+[0,durations(n)/4],[notes(n),notes(n)],'-k','linewidth',1.5);
    endif
endfor

axis([x0 x1 y0 y1]);
axis('tics','off');
box off;

# ********* Grid *************
# Vertical lines
for n = x0:0.25:x1
    if (n - floor(n) < 0.01)
        plot([n,n],[y0,y1],'-k');
        text(n,y0-1,num2str(n,'%i'));
    elseif
        plot([n,n],[y0,y1],':k');
    endif
endfor

# Horizontal lines, E
for n = MINSTAFFLINE:12:MAXSTAFFLINE
    plot([x0,x1],[n,n],'-k');
endfor

hold off;