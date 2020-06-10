FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ADD ./ubuntu-init.sh .
ADD ./user-init.sh .
RUN ./ubuntu-init.sh && ./user-init.sh && mkdir dotfiles
ADD . dotfiles/
RUN ls dotfiles/
RUN cd dotfiles; ./install.py && ./post-install.sh
ENTRYPOINT su -
