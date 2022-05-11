
# TODO 
init=2503594347247
for file in $(ls *.mp4 | sort) ; do 
    #mv $file $(echo $file | sed 's/[0-9]*.jpg$/'${i}'.jpg/')
    fname=$(basename $file)
    fname=${fname%.*}
    echo $fname
    dif=$((fname-init))
    echo $dif
done
