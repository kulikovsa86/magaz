# Magaz

Magaz - это библиотека (gem), которая поможет быстро создать интернет-магазин на базе Rails 4.

#### Установка и конфигурация

Создаем новое Rails-приложение
```bash
rails new app
```
Корректируем `Gemfile`:
```ruby
gem 'magaz', github: 'nmix/magaz'
```
Устанавливаем
```bash
bundle
```
Корректируем `config/routes.rb`
```ruby
mount Magaz::Engine => '/magaz'
```
Копируем и запускаем миграции
```bash
rake magaz:install:migrations
rake db:migrate SCOPE=magaz
```
Заполняем БД служебными и тестовыми данными
```bash
rake magaz:seed
```
Запускаем сервер `rails server` и переходим по адресу `http://localhost:3000/magaz`.
Если всё хорошо, то мы должны увидеть страницу авторизации.
E-mail: `user@example.com`
Пароль: `useruser`


#### Отображение каталога товаров


#### Страница товара


#### Характеристики товара


#### Добавление товара в корзину


#### Оформление заказа
