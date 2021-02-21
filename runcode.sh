#!/bin/bash

rm -r out/test/*
mkdir -p out/test

./bin/afines --npolymer 1 --myseed 60211589 --xrange 20 --yrange 20 --p_motor_density 0 --a_motor_density 0 --kgrow 0.1 --lgrow 1 --nlink_max 50 --kexv 0.25 --dir out/test --nmonomer 4 --nframes 200 --nmsgs 100 --tf 2

#mv out/test out/test_003



