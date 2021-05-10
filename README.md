# netcdf_web_fetch

This repo illustrates how to partially download / extract variables from NetCDF files over HTTP.

This is possible as Unidata's netcdf C library (https://github.com/Unidata/netcdf-c) has support for requesting just the required bytes
from a web server if it sends the `Accept-Ranges: bytes` response header, by sending the `Ranges` request header.

However, netcdf-bin from the default Ubuntu package repository does not have byterange support enabled, so you need to compile it yourself.

## Compile and install netcdf-c with byterange support
`sudo install.sh`

## Usage

### Output just the header from a 90GB file

Note - the #bytes suffix is required

```bash
time ncdump -h "`head -1 filelist.txt`#bytes"
```

This takes ~6s

### Download a single variable

```bash
file=`head -1 filelist.txt`
outfile=`basename $file`
time nccopy -V SSH "$file#bytes" $outfile
```

This takes ~14m

### Download multiple variables

```bash
file=`head -1 filelist.txt`
variables=(SSH SHF TAUX TAUY ADVT HMXL HBLT ADVU ADVV GRADX GRADY HDIFFU HDIFFV VDIFFU VDIFFV UVEL VVEL KE WVEL PD)
for var in "${variables[@]}"; do
    outfile=`basename -s .nc $file`_$var.nc
    echo "Downloading $outfile"
    time nccopy -V $var "$file#bytes" $outfile
done
```