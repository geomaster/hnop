#!/bin/bash
for dir 
do
    echo "Cleaning $dir"
    rm -rf $dir/js/* $dir/css/* $dir/images/* $dir/fonts/* $dir/*.html
done

