# Magaz

Magaz - это библиотека (gem), которая поможет быстро создать интернет-магазин на базе Rails 4. Данный проект разрабатывается по мотивам платформы [shoppe](https://github.com/tryshoppe/shoppe), но с уклоном на *отечественного потребителя*.

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
Данные для авторизации: e-mail -`user@example.com`, пароль:`useruser`.

#### Отображение каталога товаров

Создаем контроллер для магазина

```bash
rails generate controller store
```

Корректируем файл `app/controllers/store_controller.rb`

```ruby
class StoreController < ApplicationController
  def index
    @categories = Magaz::Category.root.children
  end
end
```

Создаем шаблон для отображения каталога `app/views/store/index.html.erb` со следующим содержанием:

```erb
<h2>Наши товары</h2>
<table>
  <% @categories.each do |category| %>
    <tr>
      <td><strong><%= category.name %></strong></td>
    </tr>
    <% category.products.each do |product| %>
      <tr>
        <td>
          <%= image_tag(product.images.first.picture.url, class: 'list_image') %>
        </td>
        <td>
          <%= product.name %>
        </td>
        <td>
          <strong><%= number_to_currency product.price%></strong>
        </td>
      </tr>
    <% end %>
  <% end %>
</table>
```

В файл `app/assets/stylesheets/store.scss` добавляем:

```css
.list_image {
  width: 60px;
  height: 70px;
}
```

В файл `config/routes.rb` добавляем строку:

```ruby
root 'store#index'
```

Запускаем сервер (если он не еше запущен)

```bash
rails server
```

Переходим по адресу `http://localhost:3000` и если всё хорошо, то наблюдаем список товаров с картинками и ценами. Если в одной позиции цена будет пропущена - ничего страшного, так задумано.

#### Страница товара

#### Характеристики товара

#### Добавление товара в корзину

#### Оформление заказа
