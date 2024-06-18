## calculate barbed end polarity from AFINES data

#-------------------segregate time----------------------------

rm data/*

mkdir -p plot_polarity

awk '/t = /{x="data/F"++i;}{print > x;}' /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/06092023/ens2/txt_stack/actins.txt

count=1				## careful using count
cd data

for tfile in F*			#-------- time loop   (*** order of input in loop maybe different than the order in view)!!!
do

touch tbarb_"$tfile"

cat $tfile > dumfile
sed '1d' dumfile > $tfile
#rm dumfile

awk -F" " '{print $1" "$2" "$3 > "data" $4 ".txt"}' $tfile

for dfile in data*		#-------- filament loop   
do

head -2 $dfile>flast1		# take first two beads		(last two=pointed end | fist two=barbed end)

awk '{$3=""; print $0}' flast1>flast2	#remove last column

paste -d " "  - - < flast2 >flast1 		# rewrite in x1 y1 x2 y2 format//  merge two lines of a file

cat flast1>>tbarb_"$tfile"

rm flast*

done				#-------- filament loop

rm data*

#sed '$d' tbarb_"$count"				
#count=`expr $count + 1`

done				#-------- time loop



cd ..


#---------------------------

cd data

for file in F*
do

sed '1d' $file > t_$file

#-------------------- segregate filaments with empty line -------------------
awk -v i=4 'NR>1 && $i!=p { print "\n" }{ p=$i } 1' t_$file > $file

#-------------------- line break for periodic boundary -------------------------
awk 'function abs(x){return ((x < 0.0) ? -x : x)}NR>1{t=prev-$1}{if(abs(t)>5)print " "}{prev=$0} 1' $file > dum_$file
awk 'function abs(x){return ((x < 0.0) ? -x : x)}NR>1{t=prev-$2}{if(abs(t)>5)print " "}{prev=$2} 1' dum_$file > t_$file

done
rm F*
rm dum* 

cd ..









### plot the barbed end vectors ####

gnuplot plotbarbed.gp

#gnuplot plotbarbed_50x50.gp





