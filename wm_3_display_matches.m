
%image path
img_path = '/home/401/Documents/public_data/VGG_DATA/oxbuild_images/';

%load feature data
data_dir = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

load([data_dir 'gnd_oxford']);
query_num = length(qidx);

%load geom information
geom   = load_ext([data_dir 'oxford_geom_sift.float'],5);
nsift  = load_ext([data_dir 'oxford_nsift.uint32']);
cndes  = [0 cumsum(double(nsift))];

%load inital query result 
load('./result/result_list_top1000_52.mat');

rank = 1000;

for k1 = 1:query_num
    q_fname = [imlist{qidx(k1)} '.jpg'];
    q_im    = imread([img_path q_fname]);    
    q_feat  = geom(:,cndes(qidx(k1))+1:cndes(qidx(k1)+1));
    
    load(sprintf('./result/matches/matche_set_128bits_ht52_q%02d.mat',k1));
    for k2 = 2:5
       db_idx   = result_list(k2,k1);
       db_fname = [imlist{db_idx} '.jpg'];
       db_im    = imread([img_path db_fname]);
       db_feat  = geom(:,cndes(db_idx)+1:cndes(db_idx+1));

       %match_idx = [];               
       match_idx = match_set{k2}(1:2,:);       
       disp_match_features_hesaff(q_im,db_im,q_feat,db_feat,match_idx,'r');
       
       fprintf('query: %d, database: %d\n', k1,k2);
    end
end
