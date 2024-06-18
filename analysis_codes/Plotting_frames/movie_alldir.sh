## make movie from AFINES data

rm -r data
rm -r plot

mkdir -p data
mkdir -p plot

# run one by one
#dataname="07052023"

# run in a loop
## declare an array variable
declare -a datarr=("08212023" "08222023" "08232023" "08242023" "08252023" "08262023" "08272023" "08282023" "08292023" "08302023")

                #------ data directory loop----------
## now loop through the above array
for i in "${datarr[@]}"
do

mkdir -p Movies/"$i"			#"$dataname"

  		#------ ens directory loop----------
ls /media/debsankar/HDD1/AFINES_analysis/OUTPUT/"$i"/

# from media: /media/debsankar/HDD1/AFINES_analysis/OUTPUT
# from desktop: /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT

for dir in /media/debsankar/HDD1/AFINES_analysis/OUTPUT/"$i"/*/			#"$dataname"
do


awk '/t = /{x="data/F"++i;}{print > x;}' "$dir"/txt_stack/actins.txt

#ls -dq *F* | wc -l

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



for FILE in t_F*; do
    gnuplot <<- EOF
        set xlabel "X"
        set ylabel "Y"   
        set term pngcairo size 620,600 font ",20"
	set key off
	unset colorbox
        set output "../plot/${FILE}.png"
        plot [-10:10][-10:10] "${FILE}" u 1:2 w lp lc 8 lw 4 ps 0.2 pt 7
EOF
done

cd ..
#----------------

savedir="$(basename $dir)"
cp -r plot Movies/"$i"/"$savedir"

done	#------ ens directory loop----------


done    #------ data directory loop --------



#  ("08212023" "08222023" "08232023" "08242023" "08252023" "08262023" "08272023" "08282023" "08292023" "08302023")
#  ("08112023" "08122023" "08132023" "08142023" "08152023" "08162023" "08172023" "08182023" "08192023" "08202023")
#  ("08012023" "08022023" "08032023" "08042023" "08052023" "08062023" "08072023" "08082023" "08092023" "08102023")
#  ("07212023" "07222023" "07232023" "07242023" "07252023" "07262023" "07272023" "07282023" "07292023" "07302023")
#  ("07112023" "07122023" "07132023" "07142023" "07152023" "07162023" "07172023" "07182023" "07192023" "07202023")
#  ("07012023" "07022023" "07032023" "07042023" "07052023" "07062023" "07072023" "07082023" "07092023" "07102023")
#  ("06012023" "06022023" "06032023" "06042023" "06052023" "06062023" "06072023" "06082023" "06092023" "06102023")
#  ("06152023" "06162023" "06172023" "06182023" "06192023" "06202023" "06212023" "06222023" "06232023" "06242023")
#  ("05052023" "05062023" "05072023" "05082023" "05152023" "05162023" "05172023" "05182023" "05132023" "05142023")
#  ("05092023" "05102023" "05112023" "05122023" "05182023")

#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)

# plot [-10:10][-10:10] "${FILE}" u 1:2 w lp lc 8 lw 4 ps 0.2 pt 7
