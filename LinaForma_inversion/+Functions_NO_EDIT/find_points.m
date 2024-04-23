function rows = find_points(path,TP,k)
for i = 1:size(path,1)
    point = path(i,:);
    if k == 1
       point(:,2) = point(:,2) * 1000;
    end
    distances = sqrt(sum((point - TP).^2, 2));
    [~, best_fit_row_index] = min(distances);
    rows(i) = best_fit_row_index;
    tp_answer(i,:) = TP(best_fit_row_index,:);
end
end
