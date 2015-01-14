function equalarea8_noline(coord, n, inc, dec, circinc, circdec, circdiam)
    %This routine generates an azimuthal equal area plot for a
    %a set of directions (inc(k), dec(k)).
    %where -90 <= inc <= 90 and 0 <= dec < 360 and dec is in CW coordinates
    %dec toward top of page = 0
    %Solid (open) circles correspond to the lower (upper) hemisphere.
    %
    %inc, dec, circinc, circdec, circdiam are each 1 x N matrices in deg.
    %coord specifies whether to read-in directions in geographic ('geo'),
    %tilt-corrected ('tilt') or core ('core') coordinates from Caltech paleomag
    %file.
    %
    %n specifies number of directions to read in/plot
    %Ben Weiss Nov 2006
    
    %Edited by Ben Burchfiel (benburch9@gmail.com) March 2013
    %This Version (7_x) designed for MATLAB 2012a
    %Edited by Ben Weiss Dec 2014 to remove bug in which error ellipses
    %were CW instead of CCW
    
    
    
    if nargin < 4
        %load data file in CW Caltech paleomag format.
        %file must be pre-edited so that the demag level column has a number!  For instance, a '0' must be added to column after NRM, a number must be added to column after high AF steps, etc.
        [FileName, PathName]=uigetfile('c:\data\matlab\matlabdata\*','Select File');
        
        fid = fopen([PathName FileName], 'r');
        C = textscan(fid, '%s %n %n %n %n %n %n %n %n %n %n %n %n %s', 'headerLines', 2);
        fclose(fid);
        
        if strcmp(coord, 'geo') == 1
            dec = C{3};
            inc = C{4};
        elseif strcmp(coord, 'tilt') == 1
            dec = C{5};
            inc = C{6};
        elseif strcmp(coord, 'core') == 1
            dec = C{9};
            inc = C{10};
        end
        
        if nargin == 2
            dec = dec(1:n);
            inc = inc(1:n);
        end
    end
    
    % convert  inclination from -90 < i < 90 to colatitude 0 < theta < 180
    inc = inc + 90;
    
    inc = inc * pi/180;
    dec = dec * pi/180;
    
    if nargin > 4
        circinc = circinc + 90;
        circinc = circinc*pi/180;
        circdec = circdec*pi/180;
        circdiam = circdiam * pi/180;
    end
    
    h = figure;
    loc = 1;
    hic = 1;
    
    for k = 1:n
        if inc(k) > pi/2
            inchi(hic) = inc(k);
            dechi (hic)= dec(k);
            hic = hic + 1;
        else
            inclo(loc) = inc(k);
            declo(loc) = dec(k);
            loc = loc + 1;
        end
    end
    
    if max(inc) > pi/2
        for l = 1: max(size(inchi))
            inchi(l) = pi/2-(inchi(l)-pi/2);
        end
    end
    
    if nargin < 3
        axesm('MapProjection','eqaazim','Grid','on','MeridianLabel','off','ParallelLabel', ...
            'on','PlabelMeridian', +90, 'Origin', [90 0 180],...
            'FLatLimit',[-Inf 115], 'FFill', 50, 'FLineWidth', 2,...
            'LabelFormat', 'compass','LabelRotation', 'off','MLabelLocation',180,...
            'PLabelLocation',[30 60], 'MLabelParallel',-10,'MapLatLimit', ...
            [90 -10],'PLineLocation',[0 15 30 45 60 75],'MLineLimit', [90 0],...
            'FontSize', 10,'FontWeight', 'bold','FontName','Helvetica');
        
    else
        % axesm('MapProjection','eqaazim','Grid','on','MeridianLabel','on','ParallelLabel', ...
        %      'on','PlabelMeridian', 0, 'Origin', [90 0 +180],...
        %    'FLatLimit',[-Inf 115], 'FFill', 50, 'FLineWidth', 2,...
        %    'LabelFormat', 'none','LabelRotation', 'off','MLabelLocation',180,...
        %   'PLabelLocation',[30 60], 'MLabelParallel',-10,'MapLatLimit', ...
        %  [90 -10],'PLineLocation',[0 15 30 45 60 75],'MLineLimit', [90 0],...
        % 'FontSize', 10,'FontWeight', 'normal','FontName','Helvetica')
        
        axesm('MapProjection','eqaazim','Grid','on','MeridianLabel','off','ParallelLabel', ...
            'on','PlabelMeridian', 0, 'Origin', [90 0 0],...
            'FLatLimit',[-Inf 115], 'FFill', 50, 'FLineWidth', 2,...
            'LabelFormat', 'none','LabelRotation', 'off','MLabelLocation',180,...
            'PLabelLocation',[30 60], 'MLabelParallel',-10,...
            'PLineLocation',[0 15 30 45 60 75],'MLineLimit', [90 0],...
            'FontSize', 10,'FontName','Helvetica');
        
        % add north, east, south, and west lables to plot
        text(0, -1.6, 'N', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center',  'FontSize', 12);
        text(1.6, 0, 'E', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center',  'FontSize', 12);
        text(0, 1.6, 'S', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center',  'FontSize', 12);
        text(-1.6, 0, 'W', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center',  'FontSize', 12);
    end
    
    gridm on; mlabelzero22pi;  hold on;%tightmap;
    framem('FlineWidth',.1,'FEdgeColor','k', 'FFill', 10^5);
    setm(gca,'FLatLimit', [-Inf, 90])
    
    
    %plot any error circles
    %heavy circles = lower hemisphere, light circles = upper hemisphere
    
    if nargin > 4
        numcirc= max(size(circinc));
        for i = 1:numcirc
            if circinc(i) <= pi/2
                [latcirc,longcirc] = scircle1(90-circinc(i)*180/pi,circdec(i)*180/pi,circdiam(i)*180/pi);
                plotm(latcirc, longcirc,'k','LineWidth',1,'LineStyle','--')
            elseif circinc(i) > pi/2
                [latcirc,longcirc] = scircle1(circinc(i)*180/pi-90,circdec(i)*180/pi,circdiam(i)*180/pi);
                plotm(latcirc, longcirc,'k','LineWidth',1.5)               
            end
            if (circinc(i) <= pi/2) & (circinc(i) + circdiam(i) > pi/2)
                [latcirc,longcirc] = scircle1(circinc(i)*180/pi-90,circdec(i)*180/pi,circdiam(i)*180/pi);
                plotm(latcirc, longcirc,'k','LineWidth',1.5, 'LineStyle','--')
            elseif (circinc(i) > pi/2) & (circinc(i) - circdiam(i) < pi/2)
                [latcirc,longcirc] = scircle1(90-circinc(i)*180/pi,circdec(i)*180/pi,circdiam(i)*180/pi);
                plotm(latcirc, longcirc,'k','LineWidth',1)
            end
        end
    end
    
    %plot directions
    %black filled points = lower hemisphere, white-filled points = upper hemisphere
    if min(inc) <= pi/2
        plotm(90-inclo*180/pi,declo*180/pi,'o','Marker','o','MarkerEdgeColor','k','MarkerFaceColor',...
            'w','MarkerSize', 8);%, 'LineStyle', '-', 'LineColor','k')
    end
    
    if max(inc) > pi/2
        plotm(90-inchi*180/pi,dechi*180/pi,'o','Marker','o','MarkerEdgeColor','k','MarkerFaceColor',...
            'k','MarkerSize', 8);% 'LineStyle', '-', 'LineColor','k')
    end
    
    % Draw a nice looking circle around plot
    for i=7:13
    x = 0;
    y = 0;
    radius = 1.405 + i*.001; % radius of circle
    deg = 0.00005; % number of polygon edges used to draw circle with
    style = 'k'; % line color, k is black
    ang=0:deg:2*pi;
    xp=radius*cos(ang);
    yp=radius*sin(ang);
    H=plot(x+xp, y+yp, style);
    set(H,'LineSmoothing','on'); % Enable AA to smooth circle
    end
    
    axis ij; % set correct orientation of plot
    axis ([-1.75 1.75 -1.75 1.75]); % set axis scale
    % End of circle drawing
       
    
    ht = uitoolbar(h);
    [X map] = imread(fullfile(matlabroot,'toolbox','matlab','icons','pdficon.gif'));
    icon = ind2rgb(X,map);
    phand = @prfig;
    uipushtool(ht,'CData',icon, 'TooltipString','Toolbar push button',...
        'ClickedCallback', phand);
    set(gcf, 'menubar', 'none');
    hold off; 
end

function y = prfig(varargin)
    % Print to pdf
    [FileName,PathName] = uiputfile('*.*', 'Select Save Location', 'New_EqualAreaPlot');
    warning('off','all');
    set(gca, 'visible', 'off');
    print(gcf, '-dpdf', '-painters', '-r1000', [PathName FileName]);
    set(gca, 'visible', 'on');
    warning('on','all');
    % End printing
    y = 1;
end

