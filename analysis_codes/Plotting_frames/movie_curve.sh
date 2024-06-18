## make movie from AFINES data

#-------------------segregate time----------------------------

rm -r data_curve
rm -r plot_curve

mkdir -p data_curve
mkdir -p plot_curve
#mkdir -p plot/cdata


cp -r ../OUTPUT/04172021/test4a/curve/data/. data_curve/

#ls -dq *F* | wc -l

#---------------------------

gnuplot plotcurve.gp

#----------------

#plot [-10:10][-10:10] "${FILE}" u 1:2:4 w lp lw 6 ps 0.75 pt 7 palette    #(colourful filaments)
