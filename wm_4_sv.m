% spatial verification

addpath('./sp_uti/');
addpath('./sp_uti/vgg_multiview/');

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

for k1 = 1:1
    q_fname = [imlist{qidx(k1)} '.jpg'];
    q_im    = imread([img_path q_fname]);   
    q_feat  = geom(:,cndes(qidx(k1))+1:cndes(qidx(k1)+1));
    
    match_sp = cell(rank,1);
    load(sprintf('./result/matches/matche_set_128bits_ht52_q%02d',k1));
    for k2 = 2:2 %the first image is the itself
       db_idx   = result_list(k2,k1);
       db_fname = [imlist{db_idx} '.jpg'];
       db_im = imread([img_path db_fname]);
       db_feat  = geom(:,cndes(db_idx)+1:cndes(db_idx+1));
       
       match_idx = match_set{k2}(1:2,:);             
       %disp_match_features_hesaff(q_im,db_im,q_feat,db_feat,match_idx,'r');
       
       match_point = match_set{k2};
       
       [match_point_ransac,opt_aff_matrix] = ransac_sp(q_feat,db_feat,match_point);
       disp_match_features_hesaff(q_im,db_im,q_feat,db_feat,match_point_ransac(1:2,:),'r');
       
       match_sp{k2} = match_point_ransac;
       fprintf('query: %d, database: %d\n', k1,k2); 
       %disp(k2);
    end
        
    save_match_path = sprintf('./result/matches_sp/matche_set_128bits_ht52_q%02d.mat',k1);
    save(save_match_path,'match_sp');
    
    disp(k1);
end