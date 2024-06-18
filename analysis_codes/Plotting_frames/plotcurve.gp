
### plot the curvature (1/rad of curv.) ####

do for [i=1:300] {
  outfile = sprintf('plot_curve/curve_%03.0f.png',i)
#  infile = sprintf('data_curve/bend_%d.txt',i)
  set xlabel "X"
  set ylabel "Y"
  set term pngcairo size 650,600 font ",20"
  set key off
  set dgrid3d 64,64
  set pm3d interpolate 0,0
  set view map
  set lmargin at screen 0.2
  set rmargin at screen 0.8
  set cbrange [0:0.03]
  set palette model RGB defined ( 0 'white', 0.01 'light-blue', 0.03 'dark-orange' )		#rgb 33,13,10, cubehelix negative
  set output outfile
  splot [-10:10][-10:10] 'data_curve/bend_'.i.'.txt' u 1:2:3 with pm3d
}
