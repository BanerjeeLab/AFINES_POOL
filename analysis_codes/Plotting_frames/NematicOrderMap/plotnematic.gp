
do for [i=1:300] {
  outfile = sprintf('plot/nxy_%03.0f.png',i)
  infile = sprintf('data/t_F%04.0f',i)
  set xlabel "X"
  set ylabel "Y"   
  set term pngcairo size 600,540
  set key off
  set cbrange [-0.6:0.6]
  set output outfile
  plot [-10:10][-10:10]  infile u 1:2:3:4 w vec nohead lc 8 lw 3 , 'data/defect_'.i.'.txt' u 1:2:3 w p ps 3 pt 7 palette
}

rese
do for [i=1:300] {
  outfile = sprintf('plot/Sxy_%03.0f.png',i)
  infile = sprintf('data/nxy_%d.txt',i)
  set xlabel "X"
  set ylabel "Y"   
  set term pngcairo size 600,600
  set key off
  #set palette rgbformulae 33,13,10
  set palette defined ( 0 '#FFFFD9',\
    	    	      1 '#EDF8B1',\
		      2 '#C7E9B4',\
		      3 '#7FCDBB',\
		      4 '#41B6C4',\
		      5 '#1D91C0',\
		      6 '#225EA8',\
		      7 '#0C2C84' )
  set pm3d map
  set pm3d interpolate 2,2
  set cbrange [0:1]
  set output outfile
  splot [-10:10][-10:10] infile u 1:2:3, 'data/defect_'.i.'.txt' u 1:2:3 w p ps 2 pt 7 lc 8
}


rese
set term pngcairo size 600,480 font ",18"
set output "defect_density_time.png"
set key off
set ticscale 0.33
pl 'data/t_ndefect.txt' u 0:4 w lp pt 7


rese
set term pngcairo size 600,480 font ",18"
set output "nematic_order_time.png"
set key off
set ticscale 0.33
pl 'data/t_ndefect.txt' u 0:5 w lp pt 7




#[-12:12][-12:12]
# plot infile u 1:2:3:4 w vec , 'data/defect_'.i.'.txt' u 1:2:3 w p ps 2 pt 7 palette
