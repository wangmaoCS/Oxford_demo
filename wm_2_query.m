
% query
data_dir = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

load([data_dir 'gnd_oxford']);
query_num = length(qidx);

%load nsift file
train_nsift = load_ext([data_dir 'oxford_nsift.uint32']);
num_db      = length(train_nsift);
num_sift    = sum(train_nsift);
num_des  = train_nsift;
cndes    = [0 cumsum(double(num_des))];  %1*n_image
clear train_nsift;

%load sift file
oxford_sift = load_ext([data_dir 'oxford_sift.uint8'],128,num_sift);
oxford_sift = desc_postprocess(oxford_sift);

% load vw file 
oxford_vw = load_ext([data_dir 'clust_preprocessed/oxford_vw.int32']);

load('./ivf_data/oxford_ivf_infor_128bits.mat');
image_num = length(imnorms);

% load Pitts data inverted index file
fivf_name = './ivf_data/oxford_ivf_128bits';
fprintf ('* Load the inverted file from %s\n', fivf_name);
ivfhe = yael_ivf_he (fivf_name);
ivfhe.verbose = false; 

%% step3 :  Query in HE invert index
ht = 52;             % Hamming Embedding threshold
nbits = 128;
scoremap = zeros (1, nbits+1);       % How we map Hamming distances to scores
sigma = 16;
scoremap(1:ht+1) = exp(-((0:ht)/sigma) .^2 );

rank = 1000;
result_list = zeros(rank,query_num);

idx_qvw = 0;
tic
for k1 = 1:query_num

    match_set = cell(rank,1);

    qvtest = oxford_sift(:,cndes(qidx(k1))+1:cndes(qidx(k1)+1) );                                         
    qvwtest = oxford_vw(cndes(qidx(k1))+1:cndes(qidx(k1)+1));
    matches = ivfhe.query(ivfhe,int32(1:size(qvtest,2)),qvtest,ht,qvwtest);

    m_imids = descid_to_imgid(matches(2,:));
    n_immatches = hist (m_imids, 1:image_num);

    idf_score = idf_data(qvwtest(matches(1,:))) .^ 2;
    idf_scoremap = scoremap (matches(3,:)+1) .* idf_score;
    n_imscores   = accumarray (m_imids, idf_scoremap', [image_num 1]) ./ (imnorms+0.00001);    

    % Images are ordered by descreasing score                 
    [~, idx] = sort (n_imscores, 'descend');
    result_list(:,k1) = idx(1:rank);
                        
    for k3 = 1:1000
        curr_match_set = matches(:,m_imids == idx(k3));
        curr_match_set(2,:) = curr_match_set(2,:) - imgid_to_descid(idx(k3));
        match_set{k3}    = curr_match_set;        
    end                            
 
    save(sprintf('result/matches/matche_set_128bits_ht%d_q%02d.mat',ht,k1),'match_set');
    disp(k1);
end
toc

% Compute mean Average Precision (mAP)
map = compute_map (result_list, gnd);
fprintf ('* mAP on Oxford5k is %.4f\n', map);

save(sprintf('./result/result_list_top1000_%d.mat',ht),'result_list');