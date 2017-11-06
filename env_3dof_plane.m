function [sys,x0,str,ts] = env_3dof_plane(t,x,u,flag,s,plot,enable)
%copyright (C) Harith Md Nasir 2017
%for support: harithmdnasir@gmail.com
    switch flag,
        case 0
            [sys,x0,str,ts] = mdlInitializeSizes;
        case 3
            sys = mdlOutputs(t,u,s,plot,enable);
        case {1,2, 4, 9}
            sys = [];
        otherwise
            error(['unhandled flag = ',num2str(flag)]);
    end
%end of main function
    
function [sys,x0,str,ts] = mdlInitializeSizes
%
	sizes = simsizes;
	sizes.NumContStates  = 0;
	sizes.NumDiscStates  = 0;
	sizes.NumOutputs     = 0;
	sizes.NumInputs      = 3;
	sizes.DirFeedthrough = 1;
	sizes.NumSampleTimes = 1;
	sys = simsizes(sizes);
	x0  = [];
	str = [];
	ts = [0.05 0];
%end of mdlInitializeSizes
    
function sys = mdlOutputs(t,u,s,plot,enable)
%	
    %plot configuration
    figure(plot);
	clf;
    if length(s) == 1
        axis([-s s -s s -s s]);
    else
        axis([-s(1) s(1) -s(1) s(1) -s(2) s(2)]);
    end
	xlabel('x (m)');
	ylabel('y (m)');
	zlabel('z (m)');
	grid on;
	hold on;
    
    %input
    z = [0; 0; 0];
    n = [u(1); u(2); u(3)];
    
    %constant
    w = 1; %plane width
    l = 1; %plane length
    F = [1 0 0; 0 1 0; 0 0 1]; %frame axis convention
    frame = [0.7;0.7;0.7]; %fram axis length
	Rx = [1 0 0; 0 cosd(n(1)) sind(n(1)); 0 -sind(n(1)) cosd(n(1))];
	Ry = [cosd(n(2)) 0 -sind(n(2)); 0 1 0; sind(n(2)) 0 cosd(n(2))];
	Rz = [cosd(n(3)) sind(n(3)) 0; -sind(n(3)) cosd(n(3)) 0; 0 0 1];
	R = Rz * Ry * Rx; %rotation matrix for R = Rz(psi)*Ry(the)*Rx(phi)
    
    if enable == 1
        
        %establish coordinate (plane center and vertices)
        p0 = F * z;
        p1 = F * (z + R*[-w/2; -l/2; 0]);
        p2 = F * (z + R*[w/2; -l/2; 0]);
        p3 = F * (z + R*[w/2; l/2; 0]);
        p4 = F * (z + R*[-w/2; l/2; 0]);
        
        %draw/plot inertial coordinate frame
        lfx = F * (z + [frame(1); 0; 0]);
        lfy = F * (z + [0; frame(2); 0]);
        lfz = F * (z + [0; 0; frame(3)]);
        plot3([lfx(1) p0(1)], [lfx(2) p0(2)], [lfx(3) p0(3)], '-b');
        plot3([lfy(1) p0(1)], [lfy(2) p0(2)], [lfy(3) p0(3)], '-b');
        plot3([lfz(1) p0(1)], [lfz(2) p0(2)], [lfz(3) p0(3)], '-b');
               
        %draw/plot body fixed coordinate frame
        lfx = F * (z + R*[frame(1); 0; 0]);
        lfy = F * (z + R*[0; frame(2); 0]);
        lfz = F * (z + R*[0; 0; frame(3)]);
        plot3([lfx(1) p0(1)], [lfx(2) p0(2)], [lfx(3) p0(3)], '-r');
        plot3([lfy(1) p0(1)], [lfy(2) p0(2)], [lfy(3) p0(3)], '-r');
        plot3([lfz(1) p0(1)], [lfz(2) p0(2)], [lfz(3) p0(3)], '-r');
        
        %draw/plot plane
        px = [p1(1) p2(1) p3(1) p4(1)];
        py = [p1(2) p2(2) p3(2) p4(2)];
        pz = [p1(3) p2(3) p3(3) p4(3)];
        fill3(px, py, pz, 1);
     
    end
    sys = [];
%end of mdlOutputs