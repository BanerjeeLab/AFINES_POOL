## make movie from AFINES data


## make movie from AFINES data

#-------------------segregate time----------------------------

mkdir -p plot_profile

cd A10/curve/data

rm a.out
rm dum.txt
rm wc.txt

for file in bend*
do

#-------------------- line break for periodic boundary -------------------------
awk 'function abs(x){return ((x < 0.0) ? -x : x)}NR>1{t=prev-$1}{if(abs(t)>5)print " "}{prev=$0} 1' $file > dum_$file
awk 'function abs(x){return ((x < 0.0) ? -x : x)}NR>1{t=prev-$2}{if(abs(t)>5)print " "}{prev=$2} 1' dum_$file > $file

done
rm F*
rm dum* 



for FILE in bend_*; do
    gnuplot <<- EOF  
        set term pngcairo size 640,600 font ",20"
	set key off
        unset tics
        unset colorbox
        set cbrange [0.0:0.1]
        set output "../../../plot_profile/${FILE}.png"
        set palette model RGB defined ( 0 'light-gray', 0.05 'light-blue', 0.1 'dark-blue' )
        plot [-10:10][-10:10] "${FILE}" u 1:2:3 w l lw 6 palette
EOF
done

cd ..
#----------------

#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)
#plot [-10:10][-10:10] "${FILE}" u 1:2 w lp lc 8 lw 4 ps 0.2 pt 7
#plot [-10:10][-10:10] "${FILE}" u 1:2:3 w lp lw 6 ps 0.75 pt 7 palette
#        set xlabel "X"
#        set ylabel "Y" 

#        set cbrange [0.0:0.2]
#        set output "../../../plot_profile/${FILE}.png"
#        set palette model RGB defined ( 0 'light-gray', 0.1 'light-blue', 0.2 'dark-blue' )
