cp data_path_from_sft .
python3 raw data processing/craftdata.py
python3 raw data processing/augment.py
bash raw data processing/generate_the_uttspk_feats_image.sh
bash raw data processing/compute_cmvn.sh
bash generating lats/generate_lats.sh
bash generating datalang/generate_datalang.sh
