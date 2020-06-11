FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ADD ./ubuntu-init.sh .
RUN ./ubuntu-init.sh
RUN useradd d33tah --create-home
USER d33tah
WORKDIR /home/d33tah
ADD ./user-init.sh .
RUN ./user-init.sh
ADD . dotfiles/
RUN ls dotfiles/
RUN cd dotfiles; ./install.py && ./post-install.sh
USER root
RUN chsh -s /usr/bin/zsh d33tah
ENTRYPOINT su - d33tah
