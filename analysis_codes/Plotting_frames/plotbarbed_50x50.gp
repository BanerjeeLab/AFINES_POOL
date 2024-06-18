
### plot the barbed end vectors ####


do for [i=1:300] {
  outfile = sprintf('plot_polarity/pb_%03.0f.png',i)
  set xlabel "X"
  set ylabel "Y"   
  set term pngcairo size 600,600
  set key off
  set output outfile
  plot [-23:23][-23:23] 'data/t_F'.i u 1:2 w l lw 1 dt 2 lc 'gray', 'data/tbarb_F'.i  using 3:4:($1-$3):($2-$4) with vectors filled head lw 3
}
