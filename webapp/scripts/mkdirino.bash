#!/bin/bash
for dir do
    if [ ! -d "$dir" ]; then
        mkdir "$dir"
    fi
done

