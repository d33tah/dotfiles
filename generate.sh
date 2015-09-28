#!/bin/sh

gpg --default-key d33tah@gmail.com --clearsign --sign message.txt
cat html-header.txt message.txt.asc html-footer.txt > index.html
