## make movie from AFINES data

#-------------------segregate time----------------------------


rm -r data
rm -r plot

mkdir -p data
mkdir -p plot

#############################   CALCULATE NEMATIC    ###################################


awk '/t = /{x="data/F"++i;}{print > x;}' /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/04172021/test0b/txt_stack/links.txt

#------ extract the time in one column -----
awk -F '= ' '{print $2}' /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/04172021/test0b/txt_stack/actins.txt > dum.txt
awk 'NF' dum.txt > dum2.txt
awk '{$2=""; print $0}' dum2.txt > data/dum.txt
rm dum2.txt

#---------------------------

cd data

#------------------ properly rename F-files --------------
for f in F[0-9]*; do
  mv "$f" "$(printf 'F%04d' "${f#F}")"
  echo "$f"
done
#---------------------------------------------------------

counter=1

for file in F*		#-------- F-file (time) loop ---------
do

sed '1d' $file > t_$file

cp t_$file afinetheta.txt

cd ..
gfortran nematic_order_defect_afines.f90
./a.out
cd data
mv nxy.txt nxy_$counter.txt
mv defect.txt defect_$counter.txt
cat tdef.txt >> timedefect.txt
counter=$((counter+1))

done			#-------- time loop ---------

rm F*

paste dum.txt timedefect.txt > t_ndefect.txt

cd ..
#----------------





#####################   CALCULATE POLAR    ##########################



awk '/t = /{x="data/F"++i;}{print > x;}' /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/04172021/test0b/txt_stack/actins.txt

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





gnuplot plotnematicpolar.gp







#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)
