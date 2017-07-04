function m3print(x)

#x=[15 16 18 15 16 18 23; 1.1 1.3 1.45 3.1 3.3 3.4 3.45; 2 1.5 4.5 2 1 0.5 4.5]

MARKERSIZE = 10;
[R,C] = size(x);

notes      = x(1,:);
onsets_raw = x(2,:);
durations  = x(3,:);

n0 = find(mod(notes,4) == 0);
n1 = find(mod(notes,4) == 1);
n2 = find(mod(notes,4) == 2);
n3 = find(mod(notes,4) == 3);

onsets_bar  = floor(onsets_raw);
onsets_beat = 10 * (onsets_raw - onsets_bar - 0.1) / 4;
onsets = onsets_bar + onsets_beat;

x0 = 1;#floor(min(onsets_raw));
x1 = ceil(max(onsets_raw + durations/4));
y0 = 8;#floor(min(notes));
y1 = max([ceil(max(notes)),44]);

# Note onsets
plot(onsets(n0), notes(n0),'ok','markersize', MARKERSIZE, 'markerfacecolor','k');
grid off;
hold on;
plot(onsets(n1), notes(n1),'vg','markersize', MARKERSIZE, 'markerfacecolor','g');
plot(onsets(n2), notes(n2),'sk','markersize', MARKERSIZE-2, 'markerfacecolor','k');
plot(onsets(n3), notes(n3),'^r','markersize', MARKERSIZE, 'markerfacecolor','r');

# Duration lines
for n = 1:C
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
for n = 8:12:44
    plot([x0,x1],[n,n],'-k');
#    plot([x0,x1],[n+0.5,n+0.5],'-k');
endfor

hold off;