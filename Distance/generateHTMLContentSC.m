function html_content = generateHTMLContentSC(folder)
% This function is for generating a string to save into the html file to
% visualize results

savepath = strcat(folder);
cost_folder = fullfile(folder,'shape context per segment');

costs = dir(fullfile(cost_folder,'*_sc_cost.mat'));

C = [];
ixmap = {};
for f = 1:size(costs,1)
    
    [pathstr,costname,ext] = fileparts(costs(f).name);
    source = fullfile(cost_folder,strcat(costname,ext));
    load(source);
    C = [C; total_cost];
    ix = strrep(costname,'_sc_cost','');    
    ixmap{f} = ix;
end

% sorting
[C_sorted, sorted_index] = sort(C, 'ascend');

% css part
html_content = ['<style type=','"text/css','"','>', ...
    '.tg  {border-collapse:collapse;border-spacing:0;}', ...
    '.tg td{font-family:Arial, sans-serif;font-size:14px;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}',...
    '.tg th{font-family:Arial, sans-serif;font-size:14px;font-weight:normal;padding:10px 5px;border-style:solid;border-width:1px;overflow:hidden;word-break:normal;}',...
    '</style>'];

% table
html_content = [html_content, '<table class="tg">'];
html_content = [html_content, '<tr>', ...
    '<th class="tg-031e">', 'filename', '</th>', ...
    '<th class="tg-031e">', 'image', '</th>', ...
    '<th class="tg-031e">', 'score', '</th>', '</tr>'];

for i = 1:length(sorted_index)
    
    index = sorted_index(i);
    
    html_content = [html_content, '<tr> ', ...
        '<td class="tg-031e">', ixmap{index}, '</td> '];
    
    html_content = [html_content, ...
        '<td class="tg-031e">', '<img src="', ...
        strcat(ixmap{index},'.png'), '" style="width:150px;height:150px"></td> '];
    
    html_content = [html_content, ...
        '<td class="tg-031e">', num2str(C(index)), '</td> </tr> '];
end

html_content = [html_content, '</table> '];

end
