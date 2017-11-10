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
