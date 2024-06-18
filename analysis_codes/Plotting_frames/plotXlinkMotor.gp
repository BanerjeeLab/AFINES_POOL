
### plot the barbed end vectors ####


do for [i=1:300] {
  outfile = sprintf('plot/t_F%04.0f.png',i)  
  infileF = sprintf('data/t_F%04.0f',i) 
  infileM = sprintf('data/t_M%04.0f',i)
  infileC = sprintf('data/t_C%04.0f',i)
  set term pngcairo size 600,600
  set key off
  unset colorbox
  set output outfile
  plot [-10:10][-10:10] infileF u 1:2 w l lc 'gray' lw 5, infileC  u 1:2 w lp lw 3 ps 0.75 pt 7 lc 'dark-green', infileM u 1:2 w lp lw 3 ps 0.75 pt 7 lc 'light-red'
}

#plot [-10:10][-10:10] 'data/t_F'.i u 1:2 w l lc 'gray' lw 5, 'data/t_C'.i  u 1:2 w lp lw 3 ps 0.75 pt 7 lc 'dark-green', 'data/t_M'.i u 1:2 w lp lw 3 ps 0.75 pt 7 lc 'light-red'
