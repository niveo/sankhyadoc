#!/bin/bash

. ./variaveis.sh

FILE1=docker-compose.yml
if [ -f "$FILE1" ]; then
    echo "Remova o arquivo $FILE1"
    exit 1
fi
FILE1=Dockerfile
if [ -f "$FILE1" ]; then
    echo "Remova o arquivo  $FILE1"
    exit 1
fi
FILE1=DOWNLOAD
if [ -d "$FILE1" ]; then
    echo "Remova o diretorio  $FILE1"
    exit 1
fi
FILE1=VOLUME
if [ -d "$FILE1" ]; then
    echo "Remova o diretorio $FILE1"
    exit 1
fi
 
cp ARQUIVOS/docker-compose.yml ./
cp ARQUIVOS/Dockerfile ./

sed -i "s/sankhyaw:TAG/sankhyaw:$TAG/g" docker-compose.yml
sed -i "s/PKG_SAS=/PKG_SAS=$PKG_SAS/g" docker-compose.yml
sed -i "s/PKG_JAVA=/PKG_JAVA=$PKG_JAVA/g" docker-compose.yml
sed -i "s/TAG=/TAG=$TAG/g" docker-compose.yml
sed -i "s/SENHA=/SENHA=$SENHA/g" docker-compose.yml
sed -i "s/NOME_SAS/$PKG_SAS/g" docker-compose.yml
sed -i "s/NOME_JAVA/$PKG_JAVA/g" docker-compose.yml


echo "Criando diretorios"
mkdir DOWNLOAD
mkdir VOLUME
mkdir VOLUME/arquivos
mkdir VOLUME/arquivos/modelos
mkdir VOLUME/arquivos/TEMP
mkdir VOLUME/arquivos/.sw_file_repository
mkdir VOLUME/java
mkdir VOLUME/pacote
mkdir VOLUME/sas
mkdir VOLUME/wildfly

#Baixando arquivos
echo "Baixando arquivos"
wget ${URL_SANKHYA}/downloads-sankhya-jdk/${VERSION_JAVA} -P DOWNLOAD/
wget ${URL_SANKHYA}/downloads-sankhya-pkgmgr/${VERSION_GPACOTE} -P DOWNLOAD/
wget ${URL_SANKHYA}/downloads-sankhya-tools/${VERSION_WILDFLY} -P DOWNLOAD/
wget ${URL_SANKHYA}/downloads-sankhya-pkgs/${VERSION_SANKHYA} -P DOWNLOAD/
wget ${URL_SANKHYA}/downloads-sankhya-sas/${VERSION_SAS} -P DOWNLOAD/

#Extraindo arquivos
echo "Extraindo arquivos"
tar -zxf DOWNLOAD/${VERSION_JAVA} --directory VOLUME/java/
unzip DOWNLOAD/${VERSION_WILDFLY} -d VOLUME/wildfly/
tar -xzf DOWNLOAD/${VERSION_GPACOTE} --directory VOLUME/pacote
tar -xzf DOWNLOAD/${VERSION_SAS} --directory VOLUME/sas

echo "Copiando sas.cfg"
cat ARQUIVOS/sas_conf > VOLUME/sas/${PKG_SAS}/conf/sas.cfg

echo "Copiando ambientes wildfly"
#Criando ambientes wildfly
cp -r VOLUME/wildfly/wildfly_producao/ VOLUME/wildfly/wildfly_teste
cp -r VOLUME/wildfly/wildfly_producao/ VOLUME/wildfly/wildfly_treina

#registrando serviços wildfly no PKG
echo "Registrando serviços wildfly no gerenciador PKG"
echo "<server><name>wildfly_producao</name><home>/home/mgeweb/wildfly_producao</home><appServer>WildFly 11.0.0.Final</appServer></server>" > VOLUME/pacote/sankhyaW_gerenciador_de_pacotes/conf/WILDFLY_PRODUCAO.xml
echo "<server><name>wildfly_teste</name><home>/home/mgeweb/wildfly_teste</home><appServer>WildFly 11.0.0.Final</appServer></server>" > VOLUME/pacote/sankhyaW_gerenciador_de_pacotes/conf/WILDFLY_TESTE.xml
echo "<server><name>wildfly_treina</name><home>/home/mgeweb/wildfly_treina</home><appServer>WildFly 11.0.0.Final</appServer></server>" > VOLUME/pacote/sankhyaW_gerenciador_de_pacotes/conf/WILDFLY_TREINA.xml


#Alterando as portas
echo "Alterar portas do wildfly"
sed -i 's/port-offset=0/port-offset=100/g' VOLUME/wildfly/wildfly_producao/bin/standalone.conf
sed -i 's/port-offset=0/port-offset=200/g' VOLUME/wildfly/wildfly_teste/bin/standalone.conf
sed -i 's/port-offset=0/port-offset=300/g' VOLUME/wildfly/wildfly_treina/bin/standalone.conf

echo "Copiando ${VERSION_SANKHYA} para o gerenciador PKG"
#Copiar o sankhya.pkg para o PKG
cp DOWNLOAD/${VERSION_SANKHYA} VOLUME/pacote/sankhyaW_gerenciador_de_pacotes/pkgs/

