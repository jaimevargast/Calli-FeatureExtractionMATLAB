function html_content = generateHtmlContentScores(dir, scores, mapping)
% This function is for generating a string to save into the html file to
% visualize results

% sorting
[scores_sorted, sorted_index] = sort(scores, 'descend');

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
        '<th class="tg-031e">', num2str(mapping(index)), '</th> '];
    
    html_content = [html_content, ...
        '<th class="tg-031e">', '<img src="', ...
        strcat(dir, num2str(mapping(index)), '.png'), '" style="width:150px;height:150px"></th> '];
    
    html_content = [html_content, ...
        '<th class="tg-031e">', num2str(scores(index)), '</th> </tr> '];
end

html_content = [html_content, '</table> '];

end
