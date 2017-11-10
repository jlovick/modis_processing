for file in `ls MOD*.tif`
do

	gdalwarp $file fr-$file -t_srs "+proj=stere +lat_0=-90 +lat_ts=-70 \
                                    +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273\
                                    +b=6356889.449 +units=m  +no_defs \
                                    +ellps=WGS84" -tr 500 500  -srcnodata "0 65535" -dstnodata "0"
	
	gdal_calc.py  -A fr-$file --outfile=st-$file --calc="A*(A<65530)" --NoDataValue=0
	
done                                           
