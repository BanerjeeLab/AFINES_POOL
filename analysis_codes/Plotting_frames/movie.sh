## make movie from AFINES data

#-------------------segregate time----------------------------

rm -r data
rm -r plot

mkdir -p data
mkdir -p plot
#mkdir -p plot/cdata


awk '/t = /{x="data/F"++i;}{print > x;}' /home/debsankar/Desktop/AFINES_cerberus_run/OUTPUT/05052023/ens2/txt_stack/actins.txt

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

#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)

# plot [-10:10][-10:10] "${FILE}" u 1:2 w lp lc 8 lw 4 ps 0.2 pt 7
