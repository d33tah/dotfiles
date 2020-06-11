FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ADD ./ubuntu-init.sh .
RUN ./ubuntu-init.sh
RUN useradd d33tah --create-home
USER d33tah
WORKDIR /home/d33tah
ADD ./user-init.sh .
RUN ./user-init.sh
ADD dotfiles dotfiles/
ADD ./install.py ./post-install.sh ./
RUN ls dotfiles/
RUN ./install.py && ./post-install.sh
USER root
RUN chsh -s /usr/bin/zsh d33tah
ENTRYPOINT su - d33tah
