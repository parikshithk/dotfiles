#!/bin/bash

cp ~/.bash_profile ./.bash_profile

git checkout master
git commit -am "update dotfiles"
git push
