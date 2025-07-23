# rarolabs

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
[![Build Status](https://img.shields.io/travis/com/your-username/rarolabs.svg?style=for-the-badge)](https://travis-ci.com/your-username/rarolabs)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

Um projeto de rede social desenvolvido com Flutter pela RaroLabs.

## 📖 Sumário

- [Sobre o Projeto](#-sobre-o-projeto)
- [🚀 Começando](#-começando)
  - [Pré-requisitos](#pré-requisitos)
  - [Instalação](#instalação)
- [🏗️ Estrutura de Pastas](#️-estrutura-de-pastas)
- [🤝 Contribuindo](#-contribuindo)
- [✅ Testes](#testes)
- [📄 Licença](#-licença)

## 💻 Sobre o Projeto

Este repositório contém o código-fonte de um aplicativo de rede social da RaroLabs, um projeto desenvolvido com Flutter. O projeto utiliza a arquitetura **MVVM (Model-View-ViewModel) combinada com princípios de Clean Architecture**, com uma estrutura organizada em camadas para uma clara separação de responsabilidades e manutenibilidade do código.

Construído com:
*   [Flutter](https://flutter.dev/)
*   [Dart](https://dart.dev/)
*   [Provider](https://pub.dev/packages/provider) para Gerenciamento de Estado
*   [GetIt](https://pub.dev/packages/get_it) para Injeção de Dependência
*   [Http](https://pub.dev/packages/http) para Requisições de Rede

## 🚀 Começando

Para ter uma cópia local do projeto rodando, siga estes passos simples.

### Pré-requisitos

Você precisa ter o Flutter SDK instalado em sua máquina. Siga o guia de instalação oficial para o seu sistema operacional.
*   [Instalação do Flutter](https://docs.flutter.dev/get-started/install)

### Instalação

1.  Clone o repositório
    ```sh
    git clone https://github.com/seu-usuario/rarolabs.git
    ```
2.  Entre no diretório do projeto
    ```sh
    cd rarolabs
    ```
3.  Instale as dependências
    ```sh
    flutter pub get
    ```
4.  Execute o aplicativo
    ```sh
    flutter run
    ```

## 🏗️ Estrutura de Pastas

O projeto segue uma arquitetura MVVM (Model-View-ViewModel) combinada com princípios de Clean Architecture, organizada em camadas para separar responsabilidades:

```
rarolabs/
├── android/                        # Código específico para Android
├── ios/                            # Código específico para iOS
├── lib/                            # O coração do aplicativo, escrito em Dart
│   ├── main.dart                   # Ponto de entrada da aplicação
│   ├── src/                        # Diretório principal para o código-fonte
│   │   ├── view/                   # Configurações gerais do app (tema, rotas)
│   │   |   ├──── pages/            # Páginas do app com seus view models
│   │   │   └──── widgets/          # Widgets reutilizáveis
│   │   ├── data/                   # Lógica de negócio, serviços, modelos
│   │   │   ├──── datasources/      # Datasources de dados
│   │   │   ├──── models/           # Modelos mapeados de retorno de API
│   │   │   └──── repositories/     # Repositórios de dados (Implementação)             
│   │   ├── domain/                 # Módulos/Funcionalidades do app
│   │   │   ├──── entites/          # Entidades de negócio
│   │   │   ├──── repositories/     # Repositórios de dados (Abstração)
│   │   │   └──── usecases/         # Casos de uso (Regras de negócio)
│   │   └── utils/                  # Utilitários compartilhados
├── test/                           # Testes unitários e de widgets
└── pubspec.yaml                    # Definições do projeto e dependências
```

## 🤝 Contribuindo

Contribuições são o que tornam a comunidade de código aberto um lugar incrível para aprender, inspirar e criar. Qualquer contribuição que você fizer será **muito apreciada**.

Se você tem uma sugestão para melhorar este projeto, por favor, crie um fork do repositório e crie um pull request. Você também pode simplesmente abrir uma issue com a tag "enhancement".

1.  Faça um Fork do projeto
2.  Crie sua Feature Branch (`git checkout -b feature/TASK-####_feature_name`)
3.  Faça o Commit de suas mudanças (`git commit -m 'Add some TASL-#### feature'`)
4.  Faça o Push para a Branch (`git push origin feature/TASK-####_feature_name`)
5.  Abra um Pull Request

## Testes

Para executar os testes, execute o seguinte comando:
```sh
flutter test
```

Para teste com cobertura (coverage):
```sh
flutter test --coverage
```

Para testes instrumentais, execute esse comando com um device conectado:
```sh
flutter test integration_test
```

## 📄 Licença

Distribuído sob a Licença MIT. Veja `LICENSE` para mais informações.
