## make movie from AFINES data

#-------------------segregate time----------------------------

for d in */		#------ directory loop----------
do

echo "$d"

cd $d

mkdir -p polar
mkdir -p polar/data

awk '/t = /{x="polar/data/F"++i;}{print > x;}' txt_stack/actins.txt

#------ extract the time in one column -----
awk -F '= ' '{print $2}' txt_stack/actins.txt > dum.txt
awk 'NF' dum.txt > dum2.txt
awk '{$2=""; print $0}' dum2.txt > polar/data/dum.txt
rm dum2.txt

#---------------------------

cd polar
cp ../../polar_order_all.f90 .

cd data		# ENTER DATA


#------------------ properly rename F-files --------------
for f in F[0-9]*; do
  mv "$f" "$(printf 'F%04d' "${f#F}")"
  echo "$f"
done
#---------------------------------------------------------

counter=1


for tfile in F*			#-------- time loop   (*** order of input in loop maybe different than the order in view)!!!
do

touch tbarb_"$tfile"

cat $tfile > dumfile
sed '1d' dumfile > $tfile
#rm dumfile

#--------------------- ALL BEADS DATA -------------------

cp $tfile allbeads.txt


#--------------------- BARBED END DATA -------------------

awk -F" " '{print $1" "$2" "$3 > "data" $4 ".txt"}' $tfile

for dfile in data*	#-------- filament loop   
do

head -2 $dfile>flast1		# take first two beads		(last two=pointed end | fist two=barbed end)

awk '{$3=""; print $0}' flast1>flast2	#remove last column

paste -d " "  - - < flast2 >flast1 		# rewrite in x1 y1 x2 y2 format//  merge two lines of a file

cat flast1>>tbarb_"$tfile"

rm flast*

done			#-------- filament loop

rm data*

cp tbarb_"$tfile" afinetheta.txt	## file with all barbed end positions at time t


cd ..		# EXIT DATA





#-------- run analysis code --------------
gfortran polar_order_all.f90
./a.out
cd data
mv pxy.txt pxy_$counter.txt
mv bxy.txt bxy_$counter.txt

counter=$((counter+1))

done				#-------- time loop

#------ compile last timeframes -------

cat pxy_250.txt pxy_255.txt pxy_260.txt pxy_265.txt pxy_270.txt pxy_275.txt pxy_280.txt pxy_285.txt pxy_290.txt pxy_295.txt > barbed_tlarge.txt

cat bxy_250.txt bxy_255.txt bxy_260.txt bxy_265.txt bxy_270.txt bxy_275.txt bxy_280.txt bxy_285.txt bxy_290.txt bxy_295.txt > allbead_tlarge.txt

#------ remove files -----------


rm F*
rm tbarb*
rm pxy_*
rm bxy_*

cd ..
#----------------

rm wc.txt
rm dum.txt
rm polar_order_all.f90

cd ../..

done




