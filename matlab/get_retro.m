%
C1=contours(lon,lat,zeta,[zref zref]);
i=1;
Nseg=0;
[M L]=size(C1);
while i<L
  pairs=C1(2,i);
  level=C1(1,i);
  segment=C1(:,i+1:i+pairs);
  [n1,n2]=size(segment);
  test_lon=segment(1,:);
  if ((n2>Nseg) &  (mean(test_lon)>20))
    Nseg=n2;
    lonseg=segment(1,:);
    latseg=segment(2,:);
  end
  i=i+pairs+1;
end
iretro=min(find(lonseg==min(lonseg(:))));
lonretro=lonseg(iretro)
latretro=latseg(iretro)
	
