function writeNODEjaime(filename,V,B)
  % WRITENODE Write vertex positions to a .node file
  %
  % writeNODE(filename,V)
  %
  % Inputs:
  %  filename  name of output file
  %  V  list of vertex positions
  %
  % Copyright 2011, Alec Jacobson (jacobson@inf.ethz.ch)
  %

  fp = fopen(filename,'w');
  % attributes are not supported
  % number of vertices  number of dimensions  0 1
  fprintf(fp,'%d %d 0 1\n',size(V));
  % .node is 1-indexed
  % build format string
  str = '%d';
  for(ii = 1:size(V,2))
    % use 0.16f so that triangle reproduces input
    str = [str ' %0.16f'];
  end
  str = [str ' %d \n'];
  indices = 1:size(V,1)';
  fprintf(fp,str,[indices' , V, B]');
  fclose(fp);
end
