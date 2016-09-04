#!/bin/bash

stage=0

if [ $stage -le 0 ]; then
  echo "---------------------------------------------------------------"
  echo "Get a frame level alignment to be used for NMI computation"

  bin="/export/b04/cliu1/kaldi-trunk/src/bin"
  alidir="/export/b04/cliu1/kaldi-trunk/egs/swbd/s5c_0420/exp/tri4_ali_train"

  $bin/ali-to-phones --per-frame $alidir/final.mdl ark:"gunzip -c $alidir/ali.*.gz |" ark,t:- | sort > ali.txt || exit 1;
fi

if [ $stage -le 1 ]; then
  filter.py /export/b04/cliu1/amdtk16/recipes/swbd/data/train.keys ali.txt ali.txt_filter || exit 1;
fi

if [ $stage -le 2 ]; then
  echo "---------------------------------------------------------------"
  echo "Making MLF"  # /export/MStuDy/Matthew/BABEL/babel-kaldi/egs/babel/babel4lorelei_V2/local_lorelei/ali2mlf.py

  lang="/export/b04/cliu1/kaldi-trunk/egs/swbd/s5c_0420/data/lang"

  ./ali2mlf.py ali.txt_filter score.ref $lang/phones.txt || exit 1;
fi

date

