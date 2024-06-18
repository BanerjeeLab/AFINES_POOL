
### plot the bending by filament colour ####

do for [i=1:301] {
  outfile = sprintf('plot_profile/curve_%03.0f.png',i)
#  infile = sprintf('data_curve/bend_%d.txt',i)
  set xlabel "X"
  set ylabel "Y"
  set term pngcairo size 620,600 font ",20"
  set key off
  unset colorbox
  set palette model RGB defined ( -0.01 'light-gray', 0.01 'light-blue', 0.03 'dark-orange' )		#rgb 33,13,10, cubehelix negative
  set output outfile
  plot 'test1/curve/data/bend_'.i.'.txt' u 1:2:3 w lp lw 6 ps 0.75 pt 7 palette
}

#[-10:10][-10:10]
