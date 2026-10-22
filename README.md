# SHEKINAH

## Deploy no Render

Este projeto é um site estático já compilado. O arquivo `render.yaml` configura o Render para publicar a pasta raiz, sem etapa de build, e encaminhar rotas da aplicação para `index.html`.

1. Envie esta pasta para um repositório Git e publique-o no GitHub ou GitLab.
2. No Render, escolha **New > Blueprint** e conecte o repositório.
3. Confirme a criação do serviço estático `shekinah`.

O Render fará novos deploys automaticamente após atualizações na branch configurada. Não é necessário configurar variáveis de ambiente para servir os arquivos. A busca bíblica da aplicação consulta `bible-api.com` no navegador e depende da disponibilidade desse serviço externo.

O servidor PowerShell e o arquivo `.bat` são apenas para execução local; o Render serve diretamente os arquivos estáticos.
