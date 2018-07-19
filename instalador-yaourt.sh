#!/usr/bin/env bash

#	Autor: Douglas Andrade de Oliveira
#	Github: https://github.com/dolts
#	Telegram: @Dolts
#	Estudante, e iniciante em shell, críticas construtivas e dicas são sempre bem vindas

#	Função: Baixar e compilar o ajudante de AUR yaourt no Arch Linux

#==================== VARIÁVEIS ====================#
_local="/tmp/build_yaourt/"
_dirP="package-query"
_dirY="yaourt"
pacoteP="package-query.git"
pacoteY="yaourt.git"

#==================== FUNÇÃO ====================#

function verifica(){
#Criando o ambiente para compilação
if [[ ! -d $_local ]]; then
	mkdir -p $_local
fi
#Verificando se o usuário rodou o script antes e evitando conflito
cd $_local
if [[ -d "$_dirP" ]] || [[ -d "$_dirY" ]]; then
	read -p "Existe uma pasta com o mesmo nome existente, deseja exclui-la para fazer a nova compilação? [s/N]  " op
	if [[ "$op" = *[sS]* ]]; then
		if ! rm -fr "$_dirP" "$_dirY"; then
			echo "Ocorreu um erro na remoção das pastas, tente remove-las manualmente e execute novamente!"
			return 1
		fi
	else
		exit
	fi
fi
}

function instala(){
cd $_local
git clone https://aur.archlinux.org/"$pacoteP"
git clone https://aur.archlinux.org/"$pacoteY"
cd "$_local""$_dirP"
if makepkg -si --noconfirm --needed; then
	echo "Package-query instalado com sucesso!"
else
	echo "Ocorreu um erro, favor verificar e tentar novamente!"
	exit
fi
cd "$_local""$_dirY"
if makepkg -si --noconfirm --needed; then
	echo "Yaourt instalado com sucesso!"
else
	echo "Ocorreu um erro, favor verificar e tentar novamente!"
	exit
fi
}

#==================== TESTE ====================#

#Verificando se é root
[[ $UID -eq "0" ]] && { echo "Executar makepkg como root não é permitido, pois isso pode causar danos catastróficos e permanentes ao seu sistema.Por favor tente novamente sem root"; exit ;}

echo "Verificando conexão com a internet, aguarde ..."

#Verificando internet
[[ $(wget -q --spider www.google.com.br) -eq "1" ]] && { echo "Verifique sua conexão com a internet e tente novamente!"; exit ;}
clear

#==================== INÍCIO ====================#

verifica
instala

echo -e "Fazendo limpeza ...\n\nProcesso concluído com sucesso!"
rm -fr $_local
