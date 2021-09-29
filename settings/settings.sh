#!/bin/bash

# Clicking on files or folders selects them instead of opening them
sed -i '/KDE/a SingleClick=false' ~/.config/kdeglobals