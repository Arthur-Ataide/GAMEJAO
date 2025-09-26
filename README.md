Como Executar o Jogo na Godot 4

Este guia explica como rodar o projeto corretamente no Godot 4.

Pré-requisitos

Godot 4.x instalado (https://godotengine.org/download
)

Git configurado em sua máquina

Clonar o repositório
Primeiro, faça o clone do repositório do projeto em sua máquina:
git clone <URL_DO_REPOSITORIO>

Depois, entre na pasta do projeto:
cd <NOME_DA_PASTA>

Alternar para a branch correta
O desenvolvimento do jogo está sendo feito na branch chamada "merge".
Execute o comando abaixo para mudar para ela:
git checkout merge

Confirme que você está na branch correta:
git branch
A branch merge deve aparecer destacada com um asterisco (*).

Abrir o projeto na Godot

Abra o Godot 4.

Clique em "Import" e selecione o arquivo project.godot dentro da pasta clonada.

O projeto será adicionado à sua lista de projetos recentes no launcher.

Executar o jogo
Com o projeto aberto na Godot, basta iniciar a depuração pressionando a tecla F5.
Isso irá executar o jogo a partir da cena principal configurada no projeto.

Resumo do fluxo:
git clone <URL_DO_REPOSITORIO>
cd <NOME_DA_PASTA>
git checkout merge

Abrir na Godot e rodar com F5

Observações

Caso haja problemas com a execução, verifique se a versão da Godot instalada corresponde à 4.x.

Sempre sincronize o repositório antes de rodar o jogo para garantir que você está com as últimas atualizações:
git pull origin merge
