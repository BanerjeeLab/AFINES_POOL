## make movie from AFINES data

#-------------------segregate time----------------------------

for d in */		#------ directory loop----------
do

echo "$d"

cd $d

mkdir -p nematic
mkdir -p nematic/data

awk '/t = /{x="nematic/data/F"++i;}{print > x;}' txt_stack/links.txt

#------ extract the time in one column -----
awk -F '= ' '{print $2}' txt_stack/actins.txt > dum.txt
awk 'NF' dum.txt > dum2.txt
awk '{$2=""; print $0}' dum2.txt > nematic/data/dum.txt
rm dum2.txt

#---------------------------

cd nematic
cp ../../nematic_order_defect_all.f90 .

cd data
#------------------ properly rename F-files --------------
for f in F[0-9]*; do
  mv "$f" "$(printf 'F%04d' "${f#F}")"
  echo "$f"
done
#---------------------------------------------------------

for file in F*		#-------- F-file (time) loop ---------
do

sed '1d' $file > t_$file

cp t_$file afinetheta.txt

cd ..
gfortran nematic_order_defect_all.f90
./a.out
cd data
cat tdef.txt >> timedefect.txt

done			#-------- time loop ---------

rm F*
rm t_F*

paste dum.txt timedefect.txt > t_ndefect.txt

cd ..
#----------------

rm wc.txt
rm dum.txt
rm nematic_order_defect_all.f90

cd ../..

done



#gnuplot plotnematic.gp
#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)
