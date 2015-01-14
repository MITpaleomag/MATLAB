function zijd14(proj, m, inc, dec);
%This routine generates a Zijderveld plot for a set of paleomag data (moment(i), incination (i), declination(i)).
%where -90 <= inclination <= 90 and 0 <= dec < 360.
%dec toward top of page = 0
%Solid (open) circles correspond to North-South (Up-Down) projections.

%m, inc, dec each N x 1 matrices in radians.
%coord specifies geographic, tilt or core coordinates. 

%Ben Weiss Aug 2009, Dec 2014

if size(m, 2) > 1
    m = m';
end
if size(dec, 2) > 1
    dec = dec';
end
if size(inc, 2) > 1
    inc = inc';
end

N = m.*cosd(inc).*cosd(dec);  %north components
E = m.*cosd(inc).*sind(dec);  %east components
Z = -m.*sind(inc);            %vertical (down) components (multiply by -1 since Z is positive downward)


figure;
if strcmp (proj,'NS') == 1
    i = plot (E, N, '-sk', 'LineWidth',1.2, 'Markersize',5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');  %black symbols: declination
    hold on;
    i = plot (E, Z, '-sk', 'LineWidth',1.2, 'Markersize',5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w');  %white symbols: inclination
    text(E(1),N(1),' \leftarrow NRM'); text(E(1),Z(1),' \leftarrow NRM')
    xlabel ('E');    ylabel ({'U';'N'});  
elseif strcmp (proj,'EW') == 1
    i = plot (N, -E, '-sk', 'LineWidth',1.2, 'Markersize',5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');  %black symbols: declination
    hold on;
    i = plot (N, Z, '-sk', 'LineWidth',1.2, 'Markersize',5, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w');  %white symbols: inclination
    text(N(1),-E(1),' \leftarrow NRM'); text(N(1),Z(1),' \leftarrow NRM')
    xlabel ('N');    ylabel ({'U';'W'});
end

set(gca, 'Box', 'off');
if strcmp (proj,'NS') == 1
    h = legend('N-E','Z-E',2);
elseif strcmp (proj,'EW') == 1
    h = legend('E-N','Z-N',2);
end
set(h,'Interpreter','none')    
axis equal; 

%determine limits of axes

if strcmp (proj,'NS') == 1
    minx = min(E) - abs(max(E)-min(E))*.1;
    maxx = max(E) + abs(max(E)-min(E))*.2;
    miny = min([Z;N]) - abs(max([Z;N])-min([Z;N]))*.1;
    maxy = max([Z;N]) + abs(max([Z;N])-min([Z;N]))*.1;
elseif strcmp (proj,'EW') == 1
    minx = min(N) - abs(max(N)-min(N))*.1;
    maxx = max(N) + abs(max(N)-min(N))*.2;
    miny = min([Z;-E]) - abs(max([Z;-E])-min([Z;-E]))*.1;
    maxy = max([Z;-E]) + abs(max([Z;-E])-min([Z;-E]))*.1;
end

if (maxx/minx > 0) 
    if minx > 0
        minx = -minx;
    else
        maxx = -maxx;
    end
end
if (maxy/miny > 0) 
    if miny > 0
        miny = -miny;
    else
        maxy = -maxy;
    end
end

xlim([minx maxx]);
ylim([miny maxy]);

%draw axes
plot ([0 0], [miny maxy], '-k');
plot ([minx maxx ], [0 0], '-k');
hold off;


