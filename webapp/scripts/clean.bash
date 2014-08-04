#!/bin/bash
for dir 
do
    echo "Cleaning $dir"
    rm -rf $dir/js/*.js $dir/css/*.css $dir/images/* $dir/fonts/* $dir/html/*.html
done

