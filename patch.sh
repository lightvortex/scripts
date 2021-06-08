export LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
export TOOLS=${LOCALDIR}/tools
export SDAT2IMG=${TOOLS}/sdat2img.py
export IMG2SDAT=${TOOLS}/img2sdat.py
export IMGEXTRACT=${TOOLS}/imgextractor.py
export MKUSERIMG=${TOOLS}/mkuserimg_mke2fs.sh
export APKTOOL=${TOOLS}/apktool
export SYSTEMDIR=${LOCALDIR}/system
export VENDORDIR=${LOCALDIR}/vendor
export OUTDIR=${LOCALDIR}/out
export INDIR=${LOCALDIR}/in

# Patch build.prop
sed -i "s/ro.product.system.device=star/ro.product.system.device=chiron/g" ${SYSTEMDIR}/system/build.prop
sed -i "s/ro.product.system.model=Star/ro.product.system.model=Mix 2/g" ${SYSTEMDIR}/system/build.prop
sed -i "s/ro.product.system.name=star/ro.product.system.name=chiron/g" ${SYSTEMDIR}/system/build.prop
sed -i "s/ro.product.system.marketname=chiron/ro.product.system.marketname=chiron/g" ${SYSTEMDIR}/system/build.prop

bytesToHuman() {
    b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Z,Y}iB)
    while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        let s++
    done
    echo "$b$d ${S[$s]}"
}

# mk img
mk_img() {
ssize=5368709120
vsize=872415232
pvsize=`du -sk ${VENDORDIR} | awk '{$1*=1024;printf $1}'`
pssize=`du -sk ${SYSTEMDIR} | awk '{$1*=1024;printf $1}'`
sout=${OUTDIR}/system.img
vout=${OUTDIR}/vendor.img
vfsconfig=${LOCALDIR}/config/vendor_fs_config
sfsconfig=${LOCALDIR}/config/system_fs_config
vfcontexts=${LOCALDIR}/config/vendor_file_contexts
sfcontexts=${LOCALDIR}/config/system_file_contexts

echo "Creating system.img"
echo "system.img size: $(bytesToHuman $pssize)"
$MKUSERIMG -s "${SYSTEMDIR}" "$sout" ext4 system $ssize -C $sfsconfig $sfcontexts -T 0  -L system > /dev/null || exit 1

echo "Creating vendor.img"
echo "vendor.img size: $(bytesToHuman $pvsize)"
$MKUSERIMG -s "${VENDORDIR}" "$vout" ext4 vendor $vsize -C $vfsconfig $vfcontexts -T 0  -L vendor > /dev/null || exit 1

rm -rf ${LOCALDIR}/config
rm -rf ${SYSTEMDIR}
rm -rf ${VENDORDIR}
}


mk_zip() {
    echo "Creating ${NEWZIP}"
    rm -rf ${NEWZIP}
    cp flashable/flashable.zip ${NEWZIP}
    $IMG2SDAT $vout -o flashable -v 4 -p vendor > /dev/null
    $IMG2SDAT $sout -o flashable -v 4 -p system > /dev/null
    cd flashable

    echo "Compressing system.new.dat"
    brotli -7 system.new.dat
    echo "Conpressing vendor.new.dat"
    brotli -7 vendor.new.dat

    rm system.new.dat || exit 1
    rm vendor.new.dat || exit 1

    zip -rv9 ../${NEWZIP} boot.img system.new.dat.br system.patch.dat system.transfer.list vendor.new.dat.br vendor.patch.dat vendor.transfer.list
    cd ..
}
