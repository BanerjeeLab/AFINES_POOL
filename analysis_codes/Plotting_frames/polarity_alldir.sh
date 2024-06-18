## calculate barbed end polarity from AFINES data

#-------------------segregate time----------------------------

rm -r data
rm -r plot_polarity

mkdir -p data
mkdir -p plot_polarity


# run one by one
#dataname="07052023"

# run in a loop
## declare an array variable
declare -a datarr=("05052023" "05062023" "05072023" "05082023" "05152023" "05162023" "05172023" "05182023" "05132023" "05142023")

                #------ data directory loop----------
## now loop through the above array
for i in "${datarr[@]}"
do

mkdir -p Polarity_Movies/"$i"			#"$dataname"  - make output directory


  		#------ ens directory loop----------
ls /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/"$i"/

for dir in /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/"$i"/*/			#"$dataname"
do

awk '/t = /{x="data/F"++i;}{print > x;}' "$dir"/txt_stack/actins.txt

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

rm data/tbarb_*

savedir="$(basename $dir)"
cp -r plot_polarity Polarity_Movies/"$i"/"$savedir"

done	#------ ens directory loop----------


done    #------ data directory loop --------
















#  ("07112023" "07122023" "07132023" "07142023" "07152023" "07162023" "07172023" "07182023" "07192023" "07202023")
#  ("07012023" "07022023" "07032023" "07042023" "07052023" "07062023" "07072023" "07082023" "07092023" "07102023")
#  ("06012023" "06022023" "06032023" "06042023" "06052023" "06062023" "06072023" "06082023" "06092023" "06102023")
#  ("05052023" "05062023" "05072023" "05082023" "05152023" "05162023" "05172023" "05182023" "05132023" "05142023")
#  ("05092023" "05102023" "05112023" "05122023" "05182023")








#gnuplot plotbarbed_50x50.gp





