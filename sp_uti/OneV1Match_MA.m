function oneMatch = OneV1Match_MA(match_points,idf_value)

    newMap = containers.Map('KeyType','double','ValueType', 'any');
    
    for k1 = 1: size(match_points,2)
        curr_key = match_points(1,k1);
        curr_val = match_points(2:4,k1);
       if(isKey(newMap,curr_key))
          newMap(curr_key) = [newMap(curr_key) curr_val];
       else
          newMap(curr_key) = curr_val; 
       
       end
    end
    
    oneMatch = [];    
    max_itr = length(newMap) ;
    for k1 = 1:max_itr 
        if(isempty(newMap))
            break;
        end
        all_key = keys(newMap);
        all_val = values(newMap);    
        min_matchSize = 100;
        for k2 = 1:length(newMap)  %find the min match size
            %if(length(all_val{k2}) < min_matchSize)
            if(size(all_val{k2},2) < min_matchSize)
               min_matchSize = size(all_val{k2},2);
               min_matchKey  = all_key{k2};
            end
        end
                
        
        if(min_matchSize == 1) % find the min hamming distance
            curr_min_hdist =  128;
            for k2 = 1:length(newMap)  %find the min match size
                %if(length(all_val{k2}) == min_matchSize)
                if(size(all_val{k2},2) == min_matchSize)
                    curr_hdist = all_val{k2}(2);                    
                    if(curr_hdist < curr_min_hdist)
                        curr_min_hdist = curr_hdist;
                        min_matchKey  = all_key{k2};
                    end
                end
            end 
        end
        
        
%         if(min_matchSize == 1) % find the max hamming distance
%             curr_min_idf =  0;
%             for k2 = 1:length(newMap)  %find the min match size
%                 %if(length(all_val{k2}) == min_matchSize)
%                 if(size(all_val{k2},2) == min_matchSize)
%                     curr_idf = idf_value( all_val{k2}(3) );                    
%                     if(curr_idf > curr_min_idf)
%                         curr_min_idf = curr_idf;
%                         min_matchKey  = all_key{k2};
%                     end
%                 end
%             end 
%         end
        
                
        list_select_match = newMap(min_matchKey);
        if(size(list_select_match,2) > 0) %non-empty 
            
            %select the best one (min hamming distance)
            [~, min_idx] = min(list_select_match(2,:));
            select_match = list_select_match(:,min_idx);

            oneMatch = [oneMatch [min_matchKey ; select_match]]; % save selected

            remove(newMap, min_matchKey);

            select_dj = select_match(1);
            all_key = keys(newMap);
            all_val = values(newMap);
            for k2 = 1:length(newMap)  %delete match corrpondence
                cur_all_dj = all_val{k2}(1,:);
                idx = (cur_all_dj ~= select_dj);
                if(idx == 0)
                    remove(newMap,all_key{k2});
                else
                    newMap(all_key{k2}) = all_val{k2}(:,idx);
                end
            end
        else  %empty 
            remove(newMap, min_matchKey);
        end
    end
    
    
final_match_size = size(oneMatch,2);
final_match_q    = unique(oneMatch(1,:));
final_match_qSize = length(final_match_q);

final_match_m    = unique(oneMatch(2,:));
final_match_mSize = length(final_match_m);

if(final_match_size ~= final_match_qSize)
    fprintf('error\n');
end

if(final_match_mSize ~= final_match_qSize)
    fprintf('error\n');
end