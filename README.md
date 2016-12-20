# Magaz

Magaz - это библиотека, которая поможет быстро создать интернет-магазин на базе Rails 4. Данный проект разрабатывается по мотивам платформы [shoppe](https://github.com/tryshoppe/shoppe), но с уклоном на *отечественного потребителя*.

[![Code Climate](https://codeclimate.com/github/nmix/magaz/badges/gpa.svg)](https://codeclimate.com/github/nmix/magaz)

[![CircleCI](https://circleci.com/gh/nmix/magaz.svg?style=svg&circle-token=1248d5b356cb774161cb279492cf2cbfce26a4b3)](https://circleci.com/gh/nmix/magaz)

#### Установка и конфигурация

Создаем новое Rails-приложение
```bash
rails new myapp
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
Данные для авторизации: e-mail -`user@example.com`, пароль:`useruser`. В админке можно управлять структорой товаров, характеристиками товаров, заказами и т.п. Этому будем посвящено отдельное руководство.

## Создаем интернет-магазин

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

Запускаем сервер (если он еще не запущен)

```bash
rails server
```

Переходим по адресу `http://localhost:3000` и если всё хорошо, то наблюдаем список товаров с картинками и ценами. Если в одной позиции цена будет пропущена - ничего страшного, так задумано.

#### Страница товара

Добавляем в контроллер `app/controllers/store_controller.rb` метод `show`

```ruby
def show
  @product = Magaz::Product.find_by_permalink(params[:id])
end
```

Создаем файл `app/views/store/show.html.erb` со следующим содержанием:

```erb
<h2><%= @product.name %></h2>
<%= @product.description %>
<br/>
<%= number_to_currency @product.price %>
<br/>
<%= image_tag(@product.images.first.picture.url, class: 'page_image') %>
<br/>
<%= link_to 'Назад', root_path %>
```

В файле `app/views/store/index.html.erb` заменяем строку `<%= product.name %>` на `<%= link_to product.name, product_path(product) %>`

Добавляем в файл `app/assets/stylesheets/store.scss` следующие строки:

```css
.page_image {
  width: 120px;
  height: 140px;
}
```

Корректируем файл `config/routes.rb`

```ruby
controller :store do
  get 'store/:id' => :show, as: 'product'
end
```

Перезапускаем сервер и переходим по адресу `http://localhost:3000`. Если мы всё сделали правильно, то наблюдаем список товаров со ссылками на страницы товара. При переходе по ссылке открывается страница соответствующего товара.

#### Характеристики товара

Для отображения характеристик товара дописываем в файл `app/views/store/show.html.erb` перед строкой `<%= link_to 'Назад', root_path %>` следующие строки:
```erb
<% @product.property_values.each do |pv| %>
  <dl>
    <dt><%= pv.property.name %></dt>
    <dd><%= pv.value %>
  </dl>
<% end %>
```

#### Добавление товара в корзину

Добавляем в контроллер `app/controllers/application_controller.rb` несколько хелперов для работы с корзиной:

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_cart, :has_cart?, :destroy_cart

  private

    def current_cart
      @cart = Magaz::Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      @cart = Magaz::Cart.create
      session[:cart_id] = @cart.id
      @cart
    end

    def has_cart?
      session[:cart_id]
    end

    def destroy_cart
      current_cart.destroy
      session[:cart_id] = nil
    end

end
```

Теперь создаем метод для обработки POST-запроса со страницы товара на добавление его в корзину

```ruby
def add2cart
  params.permit(:product_id, :variant_id, :count)
  current_cart.add_item(params)
  redirect_to cart_path
end
```

Создаем контроллер для корзины товаров:

```bash
rails generate controller carts
```

И добавляем туда метод `index` (файл `app/controllers/carts_controller.rb`)

```ruby
class CartsController < ApplicationController
  def index
    unless has_cart?
      redirect_to root_path
    else
      @cart = current_cart
      @items = @cart.items
    end
  end
end
```

Для отображения корзины создадим файл шаблона `app/views/carts/index.html.erb` следующего содержания

```erb
<%= link_to 'Каталог', root_path %>
<h2>Корзина</h2>
<table>
  <tr>
    <th>Наименование</th>
    <th>Кол-во</th>
    <th>Цена</th>
    <th>Сумма</th>
  </tr>
  <% @items.each do |item| %>
    <tr>
      <td><%= item.product.name %></td>
      <td><%= item.count %></td>
      <td><%= number_to_currency item.cart_price %></td>
      <td><%= number_to_currency item.total_cart_price %></td>
    </tr>
  <% end %>
</table>
```

В шаблон страницы товара (`app/views/products/show.html.erb`) добавляем форму для добавления этого товара в корзину (перед строкой `<%= link_to 'Назад', root_path %>`):

```erb
<%= form_tag url_for(controller: 'store', action: 'add2cart'), method: 'post' do %>
  <%= hidden_field_tag :product_id, @product.id %>
  <%= number_field_tag :count, '1' %>
  <%= submit_tag 'В корзину' %>
<% end %>
```

В самое начало страницы каталога товаров `app/views/store/index.html.erb` добавим ссылку на корзину (при ее наличии):

```erb
<% if has_cart? %>
  <%= link_to 'Корзина', cart_path %>
<% end %>
```

Крайнее, что нам необходимос сделать в данном разделе - это добавить пути для добавления товара в корзину и отображения корзины (файл `config/routes.rb)`:

```ruby
controller :store do
  get 'store/:id' => :show, as: 'product'
  post 'store/:id' => :add2cart
end

get 'cart', to: 'carts#index', as: 'cart'
```

Теперь запускаем сервер `rails server` и пробуем добавлять товары в корзину


#### Управление корзиной

Добавим функции удаления отдельных позиций из корзины и очистки корзины.
В контроллер корзины `app/controllers/carts_controllers.rb` добавим пару методов:

```ruby
def destroy
  current_cart.destroy
  session[:cart_id] = nil
  redirect_to root_path
end

def delete_item
  current_cart.delete_item(params[:id])
  if current_cart.empty?
    current_cart.destroy
    session[:cart_id] = nil
    redirect_to root_path
  else
    redirect_to cart_path
  end
end
```

Корректируем файл шаблон страницы корзины `app/views/carts/index.html.erb`:

```erb
<%= link_to 'Каталог', root_path %>
<h2>Корзина</h2>
<table>
  <tr>
    <th>Наименование</th>
    <th>Кол-во</th>
    <th>Цена</th>
    <th>Сумма</th>
    <th></th>
  </tr>
  <% @items.each do |item| %>
    <tr>
      <td><%= item.product.name %></td>
      <td><%= item.count %></td>
      <td><%= number_to_currency item.cart_price %></td>
      <td><%= number_to_currency item.total_cart_price %></td>
      <td><%= link_to 'Удалить', item_path(item), method: :delete%></td>
    </tr>
  <% end %>
</table>
<%= link_to "Очистить корзину", @cart, method: :delete %>
```

Добавляем пару маршрутов в файл `config/routes.rb`

```ruby
delete 'cart', to: 'carts#destroy'
delete 'item/:id', to: 'carts#delete_item', as: 'item'
```

Теперь мы можем удалять товары из корзины и очищать корзину.

#### Оформление заказа

В контроллер корзины `app/controllers/carts_controllers.rb` добавим методы для формирования заказа:

```ruby
# GET    /order(.:format)
def new_order
  unless has_cart?
    redirect_to root_path
  else
    @items = current_cart.items
    @order = Magaz::Order.new
  end
end

# POST   /order(.:format)
def create_order
  @order = Magaz::Order.new(params.require(:order).permit(:customer, :email, :phone))
  @order.skip_delivery_valid = true
  @order.skip_payment_valid = true
  @order.take_items_from_cart(current_cart)
  if @order.save
    destroy_cart
    redirect_to root_path, notice: 'Новый заказ создан'
  else
    @items = current_cart.items
    render :new_order
  end
end
```

Добавим новый файл шаблона для отображения формы нового заказа `app/views/carts/new_order.html.erb`:

```erb
<%= link_to 'Каталог', root_path %>
<h2>Новый заказ</h2>
<table>
  <tr>
    <th>Наименование</th>
    <th>Кол-во</th>
    <th>Цена</th>
    <th>Сумма</th>
  </tr>
  <% @items.each do |item| %>
    <tr>
      <td><%= item.product.name %></td>
      <td><%= item.count %></td>
      <td><%= number_to_currency item.cart_price %></td>
      <td><%= number_to_currency item.total_cart_price %></td>
    </tr>
  <% end %>
</table>

<%= form_for @order, url: order_path do |f| %>
  <% if @order.errors.any? %>
    <ul>
      <% @order.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  <% end %>
  <%= f.label :customer %>
  <%= f.text_field :customer %>
  <br/>
  <%= f.label :email %>
  <%= f.email_field :email %>
  <br/>
  <%= f.label :phone %>
  <%= f.text_field :phone %>
  <br/>
  <%= f.submit 'Подвердить' %>
<% end %>
<br>
<%= link_to 'Назад', :back %>

```

Добавляем ссылку на форму нового заказа в шаблон корзины `app/views/carts/index.html.erb`:

```erb
<%= link_to "Оформить заказ", order_path %>
```

В начало шаблона каталока товаров `app/views/store/index.html.erb` добавляем строки (для уведомления):

```erb
<% if notice %>
  <p><%= notice %></p>
<% end %>
```

Корректируем файл `config/routes.rb` - добавляем новые маршруты:

```ruby
get 'order', to: 'carts#new_order', as: 'order'
post 'order', to: 'carts#create_order'
```

Если всё сделали правильно, то из корзины мы можем оформить заказ. 


Подведем итог. У нас есть всё необходимое для маленького интернет-магазина: (1) каталог товаров, (2) страница товара, (3) корзина и (4) новый заказ.
Всё!
