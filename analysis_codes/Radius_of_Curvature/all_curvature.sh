## make movie from AFINES data

#-------------------segregate time----------------------------

for d in */		#------ directory loop----------
do

echo "$d"

cd $d

mkdir -p curve
mkdir -p curve/data
mkdir -p curve/plot

awk '/t = /{x="curve/data/F"++i;}{print > x;}' txt_stack/actins.txt

#------ extract the time in one column -----
awk -F '= ' '{print $2}' txt_stack/actins.txt > dum.txt
awk 'NF' dum.txt > dum2.txt
awk '{$2=""; print $0}' dum2.txt > curve/data/dum.txt
rm dum2.txt

#---------------------------

cd curve/data

rm timecurve.txt

counter=1
cp ../../../radiusofcurvature.f90 .
cp ../../../meancurve.f90 .

#------------------ properly rename F-files --------------
for f in F[0-9]*; do
  mv "$f" "$(printf 'F%04d' "${f#F}")"
  echo "$f"
done



for file in F*			#------- F-file loop --------
do
echo "$file"
sed '1d' $file > t_$file

#-------------------- segregate filaments with empty line -------------------
awk -v i=4 'NR>1 && $i!=p { print "\n" }{ p=$i } 1' t_$file > $file

#----------------- break file at each empty line: each file contain one filament
awk -v RS= '{print > ("L" NR)}' $file

#------------------ properly rename L-files --------------
for f1 in L[0-9]*; do
#  echo "$f1"
  mv "$f1" "$(printf 'L%04d' "${f1#L}")"
done

for file1 in L*			#------- L-file loop --------
do
#echo "$file1"
mv $file1 filament.txt

gfortran radiusofcurvature.f90
./a.out

done				#------- L-file loop --------

gfortran meancurve.f90
./a.out
mv curve.txt curve_$counter.txt
counter=$((counter+1))

done				#------- F-file loop --------
rm F*
rm t_*
rm filament.txt
rm radiusofcurvature.f90
rm meancurve.f90

paste dum.txt timecurve.txt > tc.txt
#rm dum.txt

cd ../../..

done				#------ directory loop----------















