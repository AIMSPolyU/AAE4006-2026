function drawAircraft(uu)
    % process inputs to function
    pn       = uu(1);       % inertial North position     
    pe       = uu(2);       % inertial East position
    pd       = uu(3);       % inertial Down    
    phi      = uu(7);       % roll angle         
    theta    = uu(8);       % pitch angle     
    psi      = uu(9);       % yaw angle     
    t        = uu(13);       % time

    % define persistent variables 
    persistent spacecraft_handle;
    persistent Vertices
    persistent Faces
    persistent facecolors
    
    % first time function is called, initialize plot and persistent vars
    if t==0
        figure(1), clf
        [Vertices, Faces, facecolors] = defineSpacecraftBody;
        spacecraft_handle = drawSpacecraftBody(Vertices,Faces,facecolors,...
                                               pn,pe,pd,phi,theta,psi,...
                                               []);
        title('Aircraft')
        xlabel('East')
        ylabel('North')
        zlabel('-Down')
        view(32,47)  % set the vieew angle for figure
        hold on
    % at every other time step, redraw base and rod
    else 
        drawSpacecraftBody(Vertices,Faces,facecolors,...
                           pn,pe,pd,phi,theta,psi,...
                           spacecraft_handle);
    end
end

%=======================================================================
% drawSpacecraft
%=======================================================================
function handle = drawSpacecraftBody(V,F,patchcolors,...
                                     pn,pe,pd,phi,theta,psi,...
                                     handle)
                                 %v'=3X11
    V = rotate(V', phi, theta, psi)';  % rotate 
    % v= in vehicle frame
    V = translate(V', pn, pe, pd)';  % translate 
    % transform vertices from NED to XYZ (for matlab rendering)
    R = [...
        0, 1, 0;...
        1, 0, 0;...
        0, 0, -1;...
        ];
    V = V*R;
    
    if isempty(handle)
        handle = patch('Vertices', V, 'Faces', F,...
            'FaceVertexCData',patchcolors,...
            'FaceColor','flat');
    else
        set(handle,'Vertices',V,'Faces',F);
        drawnow
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The rest should be done by students
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function XYZ=rotate(XYZ,phi,theta,psi)
    % define rotation matrix
    R_roll = [
        ];% to be complete by students
    R_pitch = [
        ];% to be complete by students
    R_yaw = [
        ];% to be complete by students
    R = 
    % rotate vertices
    XYZ = R'*XYZ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate vertices by pn, pe, pd
function XYZ = translate(XYZ,pn,pe,pd)
    T = [pn pe pd]';
    XYZ = XYZ + repmat(T,1, 16) ;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define spacecraft vertices and faces
function [V,F,colors] = defineSpacecraftBody()
    fuse_l1=1.5; % center of mass to tip of fuselage
    fuse_l2=1; % center of mass to widest part of fuselage
    fuse_l3=5; % center of mass to back of fuselage
    fuse_h=1;
    fuse_w=1;
    wing_l=2; % length of wing along fuselage
    wing_w=6; % wingspan
    tail_h=1;
    tailwing_l=1;
    tailwing_w=3;
    
    % Define the vertices (physical location of vertices
    V = [fuse_l1 0 0; fuse_l2 fuse_w/2 fuse_h/2; fuse_l2 -fuse_w/2 fuse_h/2; fuse_l2 -fuse_w/2 -fuse_h/2; fuse_l2 fuse_w/2 -fuse_h/2; -fuse_l3 0 0; 0 wing_w/2 0; -wing_l wing_w/2 0; -wing_l -wing_w/2 0; 0 -wing_w/2 0;-(fuse_l3-tailwing_l) tailwing_w/2 0;-fuse_l3 tailwing_w/2 0;-fuse_l3 -tailwing_w/2 0;-(fuse_l3-tailwing_l) -tailwing_w/2 0;-(fuse_l3-tailwing_l) 0 0;-fuse_l3 0 -tail_h]; % 16 vertices totally
    % to be complete by students
    
    % define faces as a list of vertices numbered above
    F = [1 1 2 3; 1 1 3 4 ; 1 1 4 5 ; 1 1 5 2;2 2 3 6;3 3 4 6;5 5 4 6; 2 2 5 6; 15 6 6 16; 7 8 9 10; 11 14 13 12]; % to be complete by students
    
    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];
    
    colors = [...
        mygreen;...  % front top
        mycyan;...  % front left
        myblue;...  % front bottom
        mycyan;...  % front right 
        mygreen;...  % main top 
        mycyan;...  % main left
        myblue;...  % main bottom 
        mycyan;...  % main right
        myred;...  % wings
        myred;...  % tailwing
        myyellow;...  % tailfin
        ];
end