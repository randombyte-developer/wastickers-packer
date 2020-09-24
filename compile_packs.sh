root_dir=$(pwd)

pushd packs
for folder in */; do
    pushd $folder

    gimp-console --batch-interpreter python-fu-eval -b "execfile('${root_dir}/export-to-png.py'); pdb.gimp_quit(0)"

    png_files=$(find -regex '.*\.png')
    for png_file in $png_files; do
        png_file_basename=$(basename -s .png $png_file)
        if [ "$png_file_basename" == "cover" ]; then continue; fi
        cwebp -z 9 $png_file -o ${png_file_basename}.webp
        rm $png_file
    done

    pack_name=$(basename $(pwd))
    echo $pack_name > title.txt
    echo "DemFisch" > author.txt
    
    zip $root_dir/compiled_packs/${pack_name}.wastickers *.png *.webp *.txt

    rm *.txt *.webp *.png

    popd
done

