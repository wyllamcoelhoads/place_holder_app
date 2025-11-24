# 📱 Place Holder App

Um aplicativo Flutter robusto desenvolvido para demonstração de consumo de API REST, gerenciamento de estado e arquitetura limpa. O projeto consome dados da [JSONPlaceholder API](https://jsonplaceholder.typicode.com/) para exibir, filtrar e detalhar postagens.

![Badge License](https://img.shields.io/badge/license-MIT-blue.svg)
![Badge Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B.svg)
![Badge Provider](https://img.shields.io/badge/State_Management-Provider-orange.svg)

---

## 📸 Screenshots
<p align="center">
  <img src="screenshots/Home.png" width="250" alt="Home" />
  <img src="screenshots/Detalhes.png" width="250" alt="Details" />
  <img src="screenshots/ZeroFavoritos.png" width="250" alt="Details" />
  <img src="screenshots/Favoritos.png" width="250" alt="Details" />
</p>

---

## ✨ Funcionalidades

- **Consumo de API REST:** Integração completa com métodos HTTP (GET).
- **Gerenciamento de Estado (Provider):** Separação total entre lógica de negócio e interface (UI).
- **Tratamento de Erros Robusto:**
  - Tratamento visual para falta de conexão (SocketException).
  - Feedback amigável para Timeouts e Erros de Servidor (404/500).
  - Botão de "Tentar Novamente" (Retry Policy).
- **Favoritos Locais:** Capacidade de marcar/desmarcar posts como favoritos (Runtime State).
- **Filtro de Quantidade:** Controle dinâmico do limite de itens buscados na API.
- **UI/UX Sofisticada:**
  - Tema escuro (Dark Mode) com paleta de cores premium.
  - Animações **Hero** na transição entre lista e detalhes.
  - Layout responsivo com tratamento de *overflow*.

---

## 🏗️ Arquitetura e Padrões

O projeto segue o padrão arquitetural **MVVM (Model-View-ViewModel)** adaptado para Flutter com o pacote **Provider**.

### Estrutura de Pastas