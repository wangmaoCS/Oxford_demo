% this script is used to compute hamming thresholds by using visual word
% and sift information

d = 128;
bits = 128;

[Q, ~] = qr (randn(d));
Q = Q(1:bits,:);

data_dir = '/home/401/Documents/public_data/INRIA_DATA/ICCV2013/';

nsift = load_ext([data_dir 'oxford_nsift.uint32']);
num_sift = sum(nsift);
num_codebook = 2^16;
threshold = zeros(bits,num_codebook); 

oxford_sift = load_ext([data_dir 'oxford_sift.uint8'],128,num_sift);
oxford_vw   = load_ext([data_dir 'clust_preprocessed/oxford_vw.int32']);

oxford_sift = desc_postprocess(oxford_sift);

for k1 = 1:num_codebook
   cur_sift = oxford_sift(:,oxford_vw == k1);
   cur_proj = Q * cur_sift;
   threshold(:,k1) = median(cur_proj,2);
   
   if (k1/1000 == round(k1/1000))
    disp(k1);
   end
   
end

save('projection_data_128bits.mat','Q','threshold');