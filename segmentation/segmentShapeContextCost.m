function cost = segmentShapeContextCost(context_ref,context)
cost = [];
for i=1:numel(context_ref)
    BH1 = context_ref{i};
    BH2 = context{i};
    hist_cost = hist_cost_2(BH1,BH2);
    this_cost = diag(hist_cost);
    this_cost = norm(this_cost);
    cost = [cost; this_cost];
end
end
    
    