function writePOLYjaime(varargin)
  % WRITEPOLYJAIME prints a vertices to a .poly file, with E connecting those vertices
  %
  % writePOLYjaime(poly_file_name,V,VB,E,B)
  % writePOLY(poly_file_name,V,VB,E,B,H)
  %
  % Input
  %   poly_file_name:  name of output file as string (caution! will clobber
  %                    existing)
  %   poly:      struct array where each element contains fields:
  %                    x,y,hole
  %     OR
  %   V  #V by 2 list of vertex positions
  %   VB #V by 1 list of vertex boundary markers
  %   E  #E by 2 list of edge E
  %   EB #E by 1 list of edge boundary markers
  %   H  #H by 2 list of hole positions
  %
  % Copyright 2011, Alec Jacobson (jacobson@inf.ethz.ch)
  %
  % See also: png2objandtga, png2poly
  %

  if(nargin == 5)
    poly_file_name = varargin{1};
    V = varargin{2};
    VB = varargin{3};    
    E = varargin{4};
    EB = varargin{5};    
  elseif(nargin == 6)
    poly_file_name = varargin{1};
    V = varargin{2};
    VB = varargin{3};    
    E = varargin{4};
    EB = varargin{5};
    H = varargin{6};
  else
    error('Wrong number of inputs');
  end
  
  % open file for writing
  poly_file_handle = fopen(poly_file_name,'w');

  % vertices section
  fprintf(poly_file_handle,'# Vertices\n');
  fprintf(poly_file_handle,'%d 2 0 1\n', size(V,1));
  for j=1:size(V,1),
    fprintf(poly_file_handle,'%d %.17f %.17f %d\n',j,V(j,1),V(j,2),VB(j));
  end

  % E section
  fprintf(poly_file_handle,'# Edges\n');
  fprintf(poly_file_handle,'%d 1\n', size(E,1));
  for j=1:size(E,1),
    fprintf(poly_file_handle,'%d %d %d %d\n',j,E(j,1),E(j,2),EB(j));
  end

  % holes section
  if(exist('H','var'))
    fprintf(poly_file_handle,'# holes\n');
    fprintf(poly_file_handle,'%d 0\n', size(H,1));
    for j=1:size(H,1),
      fprintf(poly_file_handle,'%d %.17f %.17f\n',j,H(j,1),H(j,2));
    end
  else
    % mandatory number of holes lines
    fprintf(poly_file_handle,'# holes\n');
    fprintf(poly_file_handle,'0\n');
  end

  fprintf(poly_file_handle,'\n');
  fclose(poly_file_handle);

end
