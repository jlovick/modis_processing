if [ -e ./run_swathgrid_1_processor.sh ]
	then
	rm run_swathgrid_1_processor.sh
	fi

GEOPATH="/export/molusc/antarctica/"  


for file in `cat wanted_images.txt`                                                                        
do
	GEO=`cat all_geometry.txt | grep  $file | head -n 1 | sed "s#../../#$GEOPATH#g"  `
	DATA=`cat all_images.txt | grep  $file |head -n 1 | rev | cut -d "/" -f 1 | rev`
	OUTFILE=`echo $DATA |  sed 's#.hdf##g'`
	OUTPATH=`pwd | sed 's/scripts//g'`
	echo "outpath -->  $OUTPATH"
	echo "outfile -->  $OUTFILE"
	echo " $GEO   ------>   $DATA"
	cat mst-clean.prm | sed "s#GEOFILE#$GEO#g" | sed "s#DATAFILE#$DATA#g" | sed "s#OUTPATH#$OUTPATH#g" |  sed "s#OUTFILE#$OUTFILE.tif#g" > ../$OUTFILE.prm
	echo "if [ \$(ls $OUTFILE*.tif | wc -l) -lt 4 ]" >> run_swathgrid_1_processor.sh
	echo "then " >> run_swathgrid_1_processor.sh
	echo " ~/MRTSwath/bin/swath2grid -pf=$OUTPATH$OUTFILE.prm" >> run_swathgrid_1_processor.sh
	echo "rm ./patch*" >> run_swathgrid_1_processor.sh
	echo "else " >> run_swathgrid_1_processor.sh
	echo "echo 'tif file exists'">> run_swathgrid_1_processor.sh
	echo "fi" >> run_swathgrid_1_processor.sh

done

#split -n l/5 run_swathgrid_1_processor.sh rsp
#mv rspaa ../rsp1.sh
#mv rspab ../rsp2.sh
#mv rspac ../rsp3.sh
#mv rspad ../rsp4.sh
#mv rspae ../rsp5.sh
#rm ./run_swathgrid_1_processor.sh
mv ./run_swathgrid_1_processor.sh ../make_geotifs.sh 
#if [ -e ../make_geotifs.sh ]
#	then
#	rm ../make_geotifs.sh
#	fi

#for file in `ls ../rsp?.sh | rev | cut -d "/" -f 1 | rev`
#	do
#	echo "bash $file &" >> ../make_geotifs.sh
#	done

#chmod a+x ../make_geotifs.sh

