#!/bin/bash
#SBATCH --time=41:06:66 # walltime, abbreviated by -t                           
#SBATCH --mem=110G                                                              
#SBATCH --job-name="shmerp"                                                     
#SBATCH -o mem_idx_80_classify.out-%j # name of the stdout, using the job number (%j) and the first node (%N)
#SBATCH -e mem_idx_80_classify.err-%j # name of the stderr, using the job number (%j) and the first node (%N)
#SBATCH --gres=gpu:1

source ~/.bashrc

model="$1"

#    %%  ___example_run___  %%
#
#    sbatch (model) (multi_crop) (crop_per_case) (kernels) (expansion) (depth) (aug_norm) (script) (server) 
#
#    sbatch ./train_log/model 4 20 16 12 40 0 multiThreadNet.py 1 1
# note: multi_crop==0 for single crop (non-multiple).
#multicrop=$3   #multicrop
#croppercase=$4 #crop per case
#kernels=$5     #kernels
#expansion=$6   #expansion
#depth=$7       #depth
#augrandhe=$8   #aug ramd he
#script=$9


# presets for best model:
multicrop=0   #multicrop
croppercase=0   #crop per case
kernels=12  #kernels
expansion=12  #expansion
depth=24  #depth
augrandhe=0   #aug ramd he
script='multiThreadDenseNNet_Lymphoma.py'
echo 1: model "$model", 3: multi_crop "$multicrop", 5: crop_per_case "$croppercase", 5: kernels "$kernels", 6: expansion "$expansion", 7: depth "$depth", 8: aug_randhe "$augrandhe", 9:script "$script" #, 9:py "$script" , 10:server ${10} ,

#medusa==1  fsm==0
if [ $2 -eq 1 ]
then
    conda activate slurmtftpidx
    PY='python'
    #/home/sci/samlev/anaconda3/envs/tf2/bin/python3.6'
else
    conda activate fsm_tftpidx
    PY='python'
fi

#medusa==1 fsm==0 hard assign gpu == 0
if [ $2 -eq 1 ]
then
    GPU='--num_gpu' #/home/sci/samlev/anaconda3/envs/tf2/bin/python3.6'
    N=1
else
    GPU='--gpu'
    N=1
fi

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir HQ_DLBCL --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir HQ_BL --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir PCS-17-3002 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir HP-18-643 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir HP-16-1212_1 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir HP-14-453 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir 5-HE --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir 7-HE --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-12-18833 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-18-7695 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe


$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-18-15882 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-18-0022776 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-18-26597 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-19-2811 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-19-5085 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP-19-8085 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir P --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir Q --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir R --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir SP --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir J1 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe

#$PY $script --tot test $GPU $N --mp 1 --nccl 1 --batch_size 500 --model_name res80 --load "$model" --unknown_dir J2 --depth $depth --class_weights 1,1 --crop_per_case $croppercase --multi_crop $multicrop --kernels $kernels --expansion $expansion --aug_norm 0 --aug_randhe $augrandhe
