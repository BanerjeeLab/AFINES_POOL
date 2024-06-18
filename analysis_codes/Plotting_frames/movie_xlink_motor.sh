## make movie from AFINES data

rm -r data
rm -r plot

mkdir -p data
mkdir -p plot

dir="M08012023"
ens="test1"

#====================== Filaments ============================
#-------------------segregate time----------------------------

awk '/t = /{x="data/F"++i;}{print > x;}' OUTPUT/$dir/$ens/txt_stack/actins.txt

awk '/t = /{x="data/M"++i;}{print > x;}' OUTPUT/$dir/$ens/txt_stack/amotors.txt

awk '/t = /{x="data/C"++i;}{print > x;}' OUTPUT/$dir/$ens/txt_stack/pmotors.txt

#---------------------------

cd data

#------------------ properly rename F-files --------------
for f in F[0-9]*; do
  mv "$f" "$(printf 'F%04d' "${f#F}")"
  echo "$f"
done

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


#====================== Crosslinks ==============================

#------------------ properly rename C-files --------------
for f in C[0-9]*; do
  mv "$f" "$(printf 'C%04d' "${f#C}")"
  echo "$f"
done

for file in C*
do

sed '1d' $file > t_$file

awk '{$5=$6=$7=$8=""; print $0}' t_$file>data

awk 'BEGIN{OFS=" "} {print $0, $1+$3, $2+$4}' data>data2

awk 'BEGIN{OFS=" "} {print $1, $2}{print $5, $6}{print " "}' data2>t_$file

done



#====================== Motors ==============================

#------------------ properly rename M-files --------------
for f in M[0-9]*; do
  mv "$f" "$(printf 'M%04d' "${f#M}")"
  echo "$f"
done

for file in M*
do

sed '1d' $file > t_$file

awk '{$5=$6=$7=$8=""; print $0}' t_$file>data

awk 'BEGIN{OFS=" "} {print $0, $1+$3, $2+$4}' data>data2

awk 'BEGIN{OFS=" "} {print $1, $2}{print $5, $6}{print " "}' data2>t_$file

done

cd ..	# get out of data dir

# plot filaments with motor & xlinks

gnuplot plotXlinkMotor

# save the plots for making movie

#mv plot Movies/${dir}


#----------------
