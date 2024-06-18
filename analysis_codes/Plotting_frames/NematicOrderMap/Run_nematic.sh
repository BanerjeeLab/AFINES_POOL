## make movie from AFINES data

#-------------------segregate time----------------------------


rm -r data
rm -r plot

mkdir -p data
mkdir -p plot


#/home/debsankar/WORKS/NH/AFINES/out/test0b/txt_stack/actins.txt
awk '/t = /{x="data/F"++i;}{print > x;}' /media/debsankar/HDD1/AFINES_cyto/OUTPUT/03242021/test0b/txt_stack/links.txt

#------ extract the time in one column -----
awk -F '= ' '{print $2}' /media/debsankar/HDD1/AFINES_cyto/OUTPUT/03242021/test0b/txt_stack/actins.txt > dum.txt
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


gnuplot plotnematic.gp







#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)
