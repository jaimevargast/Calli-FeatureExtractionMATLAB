function cost = fullShapeContextCost(context_ref,context)

cost = [];

BH1 = context_ref;
BH2 = context;
hist_cost = hist_cost_2(BH1,BH2);
cost = diag(hist_cost);
cost = norm(cost);    
end
    
    