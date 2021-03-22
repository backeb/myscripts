function inpoly_vec=inpoly_vec(crnlon,crnlat,plon,plat)
%function inpoly_vec=inpoly_vec(crnlon,crnlat,plon,plat)
%
% Routine to calculate wether the point (plon,plat)  is in the box
% defined by crnlon,crnlat. Cnrlon/crnlat must be traversed so that 
% they form a convex polygon in 3D coordinates when following indices.
% It should work for for all regions defined by crnlon/crnlat...
%
%Logical function, is true (1) if radial vector  of points in plon,plat is inside
%polyhedron defined by origo and points in crnlon/crnlat
%
%
%Limitations: 
% 1)Polyhedron must form a convex set in 3D-space
% 2)crnlon/crnlat must be traversed in a consistent way 
%   (always clockwise/anticlockwise)

   rad=1.7453292519943295E-02;
   deg=57.29577951308232     ;
   pip=max(size(crnlon)); % Points in crnlon/crnlat
   nt =prod(size(plon)) ; % Points to test


   % point vector from origo
   PI=1:nt;
   [pvec(1,PI),pvec(2,PI),pvec(3,PI)] = sph2cart(plon(PI)*rad,plat(PI)*rad,1.);


   % vector to rectangle corner
   [ cvec(:,1) ,  cvec(:,2) , cvec(:,3)] = sph2cart(crnlon(:)*rad,crnlat(:)*rad,1.);

   % Traverse box boundaries -- Check that traversion is
   % consistent and that point is in box
   lsign=ones(size(PI));
   i=1;
   old_rotsign=0.;
   while (i<pip+1 ),
      
      ip1= mod(i      ,pip)+1;
      im1= mod(i-2+pip,pip)+1;


      % Vectors used to span planes
      rvec(3,:) = cvec(ip1,:);
      rvec(2,:) = cvec(i  ,:);
      rvec(1,:) = cvec(im1,:);

      % Normal vector to two spanning planes
      nvec      = cross(rvec(2,:)',rvec(3,:)');
      nvec_prev = cross(rvec(1,:)',rvec(2,:)');

      % As we move to new planes, the cross product rotates in 
      % a certain direction
      cprod = cross(nvec_prev,nvec);

      % For anticlockwise rotation, this should be positive
      rotsign=sign(dot(cprod,rvec(2,:)));

      % Check that box is consistently traversed
      if (i>1 & rotsign * old_rotsign < 0)
         disp(['Grid cell not consistently traversed']);
         disp(['or polygon is not convex']);
         return
      end 
      old_rotsign=rotsign;

      % If this is true for all pip planes, we are in grid box
      %lsign = lsign & (dot(nvec,pvec)*rotsign)>=0 ;
      nvec2 = repmat(nvec,1,nt);
      %size(nvec)
      lsign = lsign & (dot(nvec2,pvec)*rotsign)>=0 ;
      %tst= (dot(nvec,pvec)*rotsign);
      i=i+1;

   end

   %What to return ....
   %inpoly_vec=find(lsign==1);
   inpoly_vec=reshape(lsign,size(plon));
      

