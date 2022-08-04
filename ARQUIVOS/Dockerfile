FROM ubuntu:20.04

ARG TAG
ARG PKG_JAVA
ARG SENHA
ARG PKG_SAS

LABEL maintainer="amendes@raimarcomercial.com.br"
LABEL version="${TAG}"
LABEL description="Instalação do sankhya completa ubuntu 20.04"

ENV USER=mgeweb
ENV DIRWORK=/home/${USER}
ENV DIRWORKDOWNLOAD=${DIRWORK}/Download 

ARG DEBIAN_FRONTEND=noninteractive

# Update Ubuntu Software repository
RUN apt update -y 
RUN apt install openssh-client -y

RUN echo 'LANG="pt_BR.ISO-8859-1" SUPPORTED="pt_BR.ISO-8859-1:pt_BR:pt" SYSFONT="latarcyrheb-sun16"' > /etc/default/locale

RUN echo "${USER} soft nofile 1024\n${USER} hard nofile 65536\n${USER} soft nproc 2047\n${USER} hard nproc 16384\n${USER} soft stack 10240\n${USER} hard stack 32768" >> /etc/security/limits.conf

#CRIAR USUARIO mgeweb
RUN useradd -m ${USER} --uid=1000 && echo "${USER}:${SENHA}" | chpasswd
RUN echo "root:${SENHA}" | chpasswd

#Colocar usuario como root para executar comandos root
USER root
RUN chown ${USER} /opt
RUN mkdir ${DIRWORKDOWNLOAD}
RUN chown ${USER} ${DIRWORKDOWNLOAD}

#Colocar usuario como mgeweb
USER ${USER}
WORKDIR ${DIRWORK}

#COPIAR ARQUIVOS
COPY ARQUIVOS/alias_profile ${DIRWORKDOWNLOAD}/
COPY ARQUIVOS/script.sh ${DIRWORKDOWNLOAD}/


#CRIAR LINK SIMBOLICO JAVA
RUN ln -s ${DIRWORK}/${PKG_JAVA}/ ${DIRWORK}/jdk8

RUN sed -i "s/NOME_SAS/$PKG_SAS/g" ${DIRWORKDOWNLOAD}/alias_profile

#COPIAR ALIAS PARA .bash
RUN cat ${DIRWORKDOWNLOAD}/alias_profile >> ${DIRWORK}/.bashrc


#Expor portar para acesso
EXPOSE 8180/tcp
EXPOSE 8280/tcp
EXPOSE 8380/tcp
EXPOSE 10050/tcp
EXPOSE 10051/tcp
EXPOSE 1433/tcp
EXPOSE 1521/tcp
