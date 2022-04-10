gr = nan(size(lt_results));
for i=1:size(lt_results,1)
    for j=1:size(lt_results,2)
       if(isa(lt_results{i,j},'struct'))
            gr(i,j) = lt_results{i,j}.gr;
       end
    end
end
