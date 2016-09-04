#!/usr/bin/env bash

# 
# Acoustic Unit Discovery based on an infinite phone-loop model.
#

if [ $# -ne 1 ] 
    then
    echo "usage: $0 <setup.sh>"
    exit 1
fi

setup=$1

source $setup || exit 1


##
export PATH="/home/cliu1/.local/bin:$PATH"
. path.sh || exit 1;
##


# Copy setup.sh to the experiment directory so that it can be re-run.
if [ -e $root/$model_type/setup.sh ]; then
  diff $setup $root/$model_type/setup.sh >/dev/null \
    || echo "Warning: $model_type/setup.sh differs; not overwriting" >&2
else
  mkdir -p $root/$model_type
  cp $setup $root/$model_type/setup.sh
fi


## local ## 
#parallel_opts="none" 

## BUT - SGE ## 
#parallel_opts="-q $queues -l matylda5=0.5"

## CLSP - SGE ##
#parallel_opts="-q $queues -l arch=\"*64\""
parallel_opts="-q $queues -l arch=\"*64\",mem_free=1G,ram_free=1G"

n=0 

stage=1
#stage=4
#stage=5

if [ $stage -le 0 ]; then
  echo "===================================================="
  echo "($((++n))) Data preparation..."
  echo "===================================================="
  ##local/prepare_data.sh \
  ##    $setup || exit 1

  #local/prepare_data_clsp.sh $setup || exit 1 # Use this on clsp grid
  echo done

  echo "===================================================="
  echo "($((++n))) Features extraction..."
  echo "===================================================="
  #utils/extract_features_db.sh \
  #    $setup \
  #    "$parallel_opts" || exit 1

      #"-q $queues -l matylda5=0.3" || exit 1
  echo done

  #date && exit 0;
fi

if [ $stage -le 1 ]; then
  echo "===================================================="
  echo "($((++n))) Creating the model..." \
    "in" $root/$model_type/initial_model "at" `date`
  echo "===================================================="
  utils/phone_loop_create.sh \
      $setup \
      $train_keys \
      $root/$model_type/initial_model || exit 1
  echo done

  echo "===================================================="
  echo "($((++n))) Training the model with unigram LM..."
  echo "===================================================="
  utils/phone_loop_train.sh \
      $setup \
      "$parallel_opts" \
      10 \
      $train_keys \
      $root/$model_type/initial_model \
      $root/$model_type/unigram || exit 1

      #"-q $queues -l matylda5=0.5" \
  echo done
fi

dir=$root/$model_type/unigram
if [ $stage -le 2 ]; then
  echo "===================================================="
  echo "Labeling "

  utils/phone_loop_label.sh $setup "$parallel_opts" $train_keys \
    $dir $dir/labels_10 || exit 1;

  echo done && date
fi

if [ $stage -le 3 ]; then
  echo "===================================================="
  echo "Scoring "

  utils/score_labels.sh $setup $train_keys $dir/labels_10 $dir || exit 1;

  echo done && date
fi


if [ $stage -le 4 ]; then
  echo "===================================================="
  echo "phone_loop_fb_post_kaldi "

  utils/phone_loop_fb_post_kaldi.sh --hmm_states \
    $setup "$parallel_opts" $train_keys \
    $dir $dir/posteriors_10 || exit 1;

  echo done && date
fi

postdir=$dir/posteriors_10
if [ $stage -le 5 ]; then
  echo "===================================================="
  echo "split_data, postdir" $postdir

  cat $train_keys | awk -v postdir=$postdir '{print $1, postdir"/"$1".ark"}' > $postdir/feats.scp || exit 1;
  awk '{print $1, $1}' $postdir/feats.scp > $postdir/utt2spk || exit 1;

  cd /export/b04/cliu1/kaldi-trunk/egs/timit/s5_0630
  ./utils/split_data.sh $postdir 96 || exit 1;

  echo done && date
fi



