
do for [i=1:300] {
  outfile = sprintf('plot/nxy_%03.0f.png',i)
  infile = sprintf('data/t_F%04.0f',i)
  set xlabel "X"
  set ylabel "Y"   
  set term pngcairo size 600,540
  set key off
  set cbrange [-0.6:0.6]
  set output outfile
  plot [-8:8][-8:8] 'data/t_F'.i u 1:2 w l lw 1 dt 2 lc 8, 'data/tbarb_F'.i  using 3:4:($1-$3):($2-$4) with vectors filled head lw 5, 'data/defect_'.i.'.txt' u 1:2:3 w p ps 4 pt 7 palette
}



#[-12:12][-12:12]
