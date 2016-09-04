# Setting python environment.            
unset PYTHONPATH                         
export PYTHONPATH=/export/b04/cliu1/amdtk16            
                                         
# Add extra tools to the PATH.           
export PATH=/home/cliu1/anaconda3/bin:/export/b04/cliu1/amdtk16/scripts:/export/b04/cliu1/amdtk16/tools/sph2pipe_v2.5:$PATH:/home/cliu1/anaconda3/bin:.:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/dell/srvadmin/bin/home/damianos/attila/bin:/home/damianos/attila/bin/linux:/home/damianos/attila/bin/linux64:/home/damianos/sctk-2.2.2/bin:/usr/local/share/SGE/bin/lx24-x86/:/home/guoguo/RESEARCH/ATTILA/attila64/bin/linux64/:/home/damianos/SRILM/bin/i686/:/home/damianos/SRILM/bin/:/home/guoguo/RESEARCH/ATTILA/:/home/guoguo/Tools/:/home/guoguo/Tools/LDC-CN-SEG/:/home/guoguo/Tools/usr/bin/:/home/puyang/Tools/:/home/samuel/bin/bin64/:/home/sivaram/speech_tools/bin/:/home/guoguo/Tools/lib/:/home/guoguo/Tools/include/:/home/guoguo/Tools/bin/:/home/guoguo/Tools/scripts/:/home/guoguo/RESEARCH/ATTILA/attila64/bin/linux64/:/home/damianos/SRILM/bin/i686/:/home/damianos/SRILM/bin/:/home/guoguo/RESEARCH/ATTILA/:/home/guoguo/Tools/:/home/guoguo/Tools/LDC-CN-SEG/:/home/guoguo/Tools/usr/bin/:/home/puyang/Tools/:/home/samuel/bin/bin64/:/home/sivaram/speech_tools/bin/:/home/guoguo/Tools/lib/:/home/guoguo/Tools/include/:/home/guoguo/Tools/bin/:/home/guoguo/Tools/scripts/              
                                         
# Selecting the AMDTK environment.       
source activate py35_amdtk                
                                         
# Disable multithreading.                
export OPENBLAS_NUM_THREADS=1            
export OMP_NUM_THREDS=1                  
export MKL_NUM_THREADS=1                 
