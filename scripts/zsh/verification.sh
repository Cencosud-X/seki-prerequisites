#!/bin/bash
OHMYZSHPATH="$HOME/.oh-my-zsh";

if [ -d $OHMYZSHPATH ]; then
  echo '🟢 Oh My Zsh already exists';
else
  echo '🟡 Oh My Zsh is not installed';
  exit 1; # OH MY ZSH IS NOT INSTALLED!
fi