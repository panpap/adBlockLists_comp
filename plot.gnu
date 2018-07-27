set terminal  png

set grid y lt 0 lw 1 lc rgb "#B8B8B8"
set yrange [0:100]
set ytics offset 0.5,0
set format y "%.0f%%"
set key bottom right
set log x
set ylabel "CDF" offset 1,0
set out "blockedResources_cdf.png"
set xlabel "Number of blocked resources"
plot 'easyListResults_resultsAlexaGlobal10.log_cdf.csv' u 1:4 t 'easyList(Global)' w lines lw 3, \
'easyPrivacyResults_resultsAlexaGlobal10.log_cdf.csv' u 1:4 t 'easyList(Global)' w lines  lw 3, \
'easyChinaResults_resultsAlexaGlobal10.log_cdf.csv' u 1:4 t 'easyList(Global)' w lines lw 3, \
'easyListResults_resultsAlexaChina10.log_cdf.csv' u 1:4 t 'easyList(China)' w lines  lw 3, \
'easyPrivacyResults_resultsAlexaChina10.log_cdf.csv' u 1:4 t 'easyPrivacy(China)' w lines  lw 3, \
'easyChinaResults_resultsAlexaChina10.log_cdf.csv' u 1:4 t 'easyChina(China)' w lines  lw 3, \


