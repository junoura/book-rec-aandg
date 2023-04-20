savefolder="/Users/YOURNAME/Desktop"
ffmpegplace="/Users/YOURNAME/Downloads/ffmpeg"

calendarhour=`date '+%H'`
calendarmin=`date '+%M'`
calendaryyyymmdd=`date '+%F'`

while read line
do
    if [[ $line == *Summary:* ]]; then
	title=${line:9}
	title=${title//\// }
	flg=0
    fi
    if [[ $line == *Notes:* ]]; then
	notes=${line:7}
	if [ "$flg" -eq 1 ]
	then
	    rectitle=${title}${calendaryyyymmdd}
	    recnotes=${notes}
	    reclength=${length}
	fi
    fi
    if [[ $line == *Time:* ]]; then
	timestr=${line:6}
	arr=( `echo $timestr`)
	starttime=${arr[0]}
	startarr=( `echo $starttime | tr -s ':' ' '`)
	starthour=${startarr[0]}
	startmin=${startarr[1]}
	endtime=${arr[2]}
	endarr=( `echo $endtime | tr -s ':' ' '`)
	endhour=${endarr[0]}
	endmin=${endarr[1]}
	if [ "$starthour" -eq 23 ] && [ "$endhour" -eq 0 ]
	then
	    endhour=24
	fi
	length=`expr $endhour - $starthour`
	length=`expr $length \* 60`
	length=`expr $length + $endmin - $startmin`
	length=`expr ${length} \* 60`
	if [ "$starthour" -eq "$calendarhour" ] && [ "$startmin" -eq "$calendarmin" ]
	then
	    flg=1
	fi
    fi
done < $savefolder/automator_temp.txt
rm $savefolder/automator_temp.txt
$ffmpegplace -t ${reclength} -i "https://www.uniqueradio.jp/agapps/hls/cdn.m3u8" -vf "scale=320x180" "$savefolder/${rectitle}.ts"
    if [[ $recnotes == "mp4" ]]; then
	$ffmpegplace -y -i "$savefolder/${rectitle}.ts" -vcodec libx264 -acodec aac "$savefolder/${rectitle}.mp4"
    fi
    if [[ $recnotes == "mp3" ]]; then
	$ffmpegplace -y -i "$savefolder/${rectitle}.ts" -acodec libmp3lame "$savefolder/${rectitle}.mp3"
    fi
    if [[ $recnotes == "" ]]; then
	$ffmpegplace -y -i "$savefolder/${rectitle}.ts" -vcodec libx264 -acodec aac "$savefolder/${rectitle}.mp4"
	$ffmpegplace -y -i "$savefolder/${rectitle}.ts" -acodec libmp3lame "$savefolder/${rectitle}.mp3"
    fi

rm "$savefolder/${rectitle}.ts"



