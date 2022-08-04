
# Inicial
- Docker e Docker Compose Instalado
- Git instaldo para clone ou [Download](https://github.com/niveo/sankhyadoc)
- Imagem do SO usada Ubuntu 20.04

## Arquivos e documentação usadas
- [Premissas](https://ajuda.sankhya.com.br/hc/pt-br/articles/360045373654-Premissas-e-Pr%C3%A9-requisitos-para-implanta%C3%A7%C3%A3o)
- [Documentação](https://ajuda.sankhya.com.br/hc/pt-br/articles/360045547894-Manual-de-Instala%C3%A7%C3%A3o-SankhyaW-em-Ambiente-Linux) 
- [Video Consultor](https://vimeo.com/639201281)

## Clone o projeto
git clone https://github.com/niveo/sankhyadoc

## Para fazer uma migração verificar qual versão do pacote esta instalado
`SELECT TEXTO FROM SANKHYA_TREINAMENTO.sankhya.TSIPAR WHERE CHAVE = 'VERSAOSKWDD'`

Exemplo versão atual 4.8b442 informar essa mesma versão no arquivo de variáveis *VERSION_SANKHYA


# SAS

## Verificar os parametros ip sas e trocar caso necessário.
```SELECT TEXTO FROM SANKHYA_TREINAMENTO.sankhya.TSIPAR WHERE CHAVE = 'IPSERVACESS'```

Coloque o IP do servidor onde sera instalado o sas

Pode ser usado ip com porta caso tenha trocado no parametro server.port=10051 no sas.cfg

ex: 192.168.0.0:10051

default 10050

```UPDATE SANKHYA_TREINAMENTO.sankhya.TSIPAR SET TEXTO = '192.168.0.0' WHERE CHAVE = 'IPSERVACESS'```

## Verificar os parametros de diretorio e  trocar caso necessário.
```
SELECT TEXTO FROM SANKHYA_TREINAMENTO.sankhya.TSIPAR WHERE CHAVE = 'PATHTEMP'
SELECT TEXTO FROM SANKHYA_TREINAMENTO.sankhya.TSIPAR WHERE CHAVE = 'SERVDIRMOD'
UPDATE SANKHYA_TREINAMENTO.sankhya.TSIPAR SET TEXTO = '/home/mgeweb/Arquivos_Sankhya/Layouts' WHERE CHAVE = 'SERVDIRMOD'
UPDATE SANKHYA_TREINAMENTO.sankhya.TSIPAR SET TEXTO = '/home/mgeweb/temp' WHERE CHAVE = 'PATHTEMP'
```

## Configuração do sas.cfg
Altere o ARQUIVOS/sas_conf conforme o banco

```
#Arquivo de configura??es do SAS - Gerado pelo instalador.
#Thu Jan 13 15:17:47 BRST 2005
client.response.timeout=50000
client.ping.interval=50000

connection.url=jdbc:oracle:thin:@localhost:1521:XE
driver.classname=oracle.jdbc.driver.OracleDriver
module.multi.host=true
package.name=oracle.jar
db.vendor=oracle
db.username=sankhya
db.password=tecsis
server.timeout=50000
product.line=MGE
ping=client
```

### Se MS SQL Server ###
```
package.name=mssql
db.vendor=mssql
```

- DRIVER CLASS NAME

`driver.classname=net.sourceforge.jtds.jdbc.Driver`

- URL de Conexão para Microsof SQL Server com Instância Nomeada

`connection.url=jdbc:jtds:sqlserver:IP_DO_BANCO_DE_DADOS:1433/NOME_DA_BASE_DE_DADOS;instance=INSTANCE_NAME;lastUpdateCount=true`

- URL de Conexão para Microsof SQL Server

`connection.url=jdbc:jtds:sqlserver:IP_DO_BANCO_DE_DADOS:1433/NOME_DA_BASE_DE_DADOS;lastUpdateCount=true`


# Variáveis 
Altere as variaves do variaveis.sh conforme requisitos

- SENHA=
- TAG=0.23
- PKG_SAS=SAS3.1b16
- PKG_JAVA=jdk1.8.0_231
- VERSION_JAVA=jdk-8u231-linux-x64.tar.gz
- VERSION_GPACOTE=pkgmgr_snk_unix_x64_2_3b85.tar.gz
- VERSION_WILDFLY=Wildfly_11.0_Sankhya_mod_06.zip
- VERSION_SAS=SAS_3_1b16_Sankhya_unixx64.tar.gz
- VERSION_SANKHYA=sankhya-w_4.8b442.pkg

SENHA=*Esse parametro vai conter a senha do root e do mgeweb

Execute sh init.sh para criar o ambiente


# Docker
## Iniciar o container
```sudo docker-compose -f docker-compose.yml up -d```


## Pegar o containerID EX 643b78c2184c
`sudo docker ps -a`

## Entrar / Atachar o containerID
`sudo docker attach 643b78c2184c`

# Dentro do Sistema

## Após instalar entrar no container e executar /home/mgeweb/Download/script.sh  para dar permissões
`sh script.sh`

## Iniciar sas
`sasstart`

## Iniciar wildfly/jboss
`jb_starttreina`

## Sair sem matar o serviço no docker
`CTRL+p+q`


#Para subir o container e widlfly e sas automaticamente fica a critério do consultor.
