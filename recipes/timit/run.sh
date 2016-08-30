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

echo "===================================================="
echo "($((++n))) Creating the model..."
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

