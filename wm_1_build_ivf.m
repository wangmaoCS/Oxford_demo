data_dir = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

%load nsift file
train_nsift = load_ext([data_dir 'oxford_nsift.uint32']);
num_db      = length(train_nsift);
num_sift    = sum(train_nsift);
num_des  = train_nsift;
cndes    = [0 cumsum(double(num_des))];  %1*n_image
clear train_nsift;

%load projection and medi
load('projection_data_128bits.mat','Q','threshold');

% load centroids file
train_C = load_ext([data_dir 'clust_preprocessed/oxford_codebook.fvecs']);
num_codebook = size(train_C,2);

% load vw file 
oxford_vw = load_ext([data_dir 'clust_preprocessed/oxford_vw.int32']);

nbits = 128;

oxford_sift = load_ext([data_dir 'oxford_sift.uint8'],128,num_sift);
oxford_sift = desc_postprocess(oxford_sift);

v     = oxford_sift(:,1:1000);
idx   = oxford_vw(1:1000);
ivfhe = yael_ivf_he (num_codebook, nbits, v, @yael_kmeans, train_C, idx);
ivfhe.medians = single( threshold );
ivfhe.Q = Q;
clear threshold;
clear Q;
clear pitts_C;

% compute idf value
idf_num = hist(oxford_vw,1:num_codebook);
idf_data = zeros(1,num_codebook);
for k1 = 1:num_codebook
    if(idf_num(k1) > 0)
        idf_data(k1) = log(num_db ./ idf_num(k1));
    end
end

% extra information
imnorms = zeros(num_db,1);
descid_to_imgid = zeros (sum(num_des), 1);  % desc to image conversion
imgid_to_descid = zeros (num_db, 1);      % for finding desc id
lastid = 0;

for k1 = 1:num_db    
    if (num_des(k1)==0)
        continue;
    end
        
    vtest = oxford_sift(:,[cndes(k1)+1: cndes(k1+1)]);                
    vwtest = oxford_vw(cndes(k1)+1:cndes(k1+1));
    
    [~, codes] = ivfhe.add (ivfhe, lastid+(1:num_des(k1)), double(vtest), vwtest);
    tmp_hist = hist(vwtest,1:num_codebook);
    imnorms(k1) = norm(tmp_hist .* idf_data);
    
    descid_to_imgid(lastid+(1:num_des(k1))) = k1;
    imgid_to_descid(k1) = lastid;
    lastid = lastid + num_des(k1);
    if round(k1 / 100 ) == (k1 /100)
        disp(k1);
    end
    
end

ivf_fname = './ivf_data/oxford_ivf_128bits';
ivfhe.save(ivfhe,ivf_fname);
save('./ivf_data/oxford_ivf_infor_128bits.mat','imnorms','descid_to_imgid','imgid_to_descid','idf_data');