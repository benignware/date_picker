# date_picker
> Rails DatePicker-Integration

* Supports [bootstrap-datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker), [flatpickr](https://chmln.github.io/flatpickr/), [jqueryui-datepicker](https://jqueryui.com/datepicker/) and [pickadate](http://amsul.ca/pickadate.js/)
* Seamless i18n-Integration
* FormBuilder- and SimpleForm-Helpers for date, datetime and time-attributes
* HTML5-Fallback on Mobile

## Install

Add the following to your Gemfile:

```cli
gem 'date_picker'
```

DatePicker does not bundle any third-party assets. 
It is recommended to utilize a package manager to download client-side dependencies.
Examples assume, you're using [bower](http://bower.io). 

Integrate bower into your rails-app by running `bower init` from command-line:

```cli
bower init
```

Create a `.bowerrc`-file to point bower's installation directory to `vendor/assets/components`:
```json
{
  "directory": "vendor/assets/components"
}
```

Add bower components to asset paths:
```ruby
# config/application.rb
config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
```


### Bootstrap DateTimePicker

[bootstrap-datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker)

Run the config-generator

```cli
rails g date_picker:config :bootstrap
```

Install dependencies via bower

```cli
bower install bootstrap --save
bower install eonasdan-bootstrap-datetimepicker --save
```

Require javascript dependencies

```javascript
// app/assets/javascripts/application.js
//= require jquery/dist/jquery.min
//= require moment/min/moment-with-locales.min
//= require moment-timezone/builds/moment-timezone-with-data.min
//= require moment/min/locales.min
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
```

Require css dependencies

```css
/* app/assets/stylesheets/application.css
 *= require bootstrap/dist/css/bootstrap.min
 *= require eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min
 */
```

### Flatpickr

[flatpickr](https://chmln.github.io/flatpickr/)

Run the config-generator

```cli
rails g date_picker:config :flatpickr
```

Install dependencies via bower

```cli
bower install flatpickr-calendar --save
```

Require javascript dependencies

```javascript
// app/assets/javascripts/application.js
//= require flatpickr/dist/flatpickr.min
//= require flatpickr/src/flatpickr.l10n.de
```

Require css dependencies

```css
/* app/assets/stylesheets/application.css
 *= require flatpickr/dist/flatpickr.min
 */
```

### jQueryUI DatePicker

[jqueryui-datepicker](https://jqueryui.com/datepicker/)

Run the config-generator using `:jquery_ui`
```cli
rails g date_picker:config :jquery_ui
```

Install dependencies via bower
```cli
bower install jquery-ui --save
```

Require javascript dependencies

```javascript
// app/assets/javascripts/application.js
//= require jquery/dist/jquery.min
//= require jquery-ui/jquery-ui.min
```

Require css dependencies

```css
/* app/assets/stylesheets/application.css
 *= require jquery-ui/themes/smoothness/jquery-ui.min
 *= require jquery-ui/themes/smoothness/theme
 */
```

### PickADate

[pickadate](http://amsul.ca/pickadate.js/)


Run the config-generator
```cli
rails g date_picker:config :pickadate
```

Install dependencies via bower
```cli
bower install pickadate --save
```

Require javascript dependencies

```javascript
// app/assets/javascripts/application.js
//= require jquery/dist/jquery.min
//= require pickadate/lib/compressed/picker
//= require pickadate/lib/compressed/picker.date
//= require pickadate/lib/compressed/picker.time
```

Require css dependencies

```css
/* app/assets/stylesheets/application.css
 *= require pickadate/lib/themes/classic
 *= require pickadate/lib/themes/classic.date
 *= require pickadate/lib/themes/classic.time
 */
```


## Form helpers

The date_picker-Module provides tag helpers, form-builder helpers and simple_form-helpers for attributes of type `:date`, `:datetime` and `:time`.

> Please note that jqueryui-datepicker can only handle dates, while bootstrap-datetimepicker also supports attributes of type `:datetime` and `:time`. Form helpers will fall back to the corresponding standard-rails date_select-helpers. 

### FormTagHelper

Use the form-tag-helper for non-model purposes:  
```erb
date_picker_tag(name, value, options = {})
datetime_picker_tag(name, value, options = {})
time_picker_tag(name, value, options = {})
```

### FormBuilder

Scaffold an example model and migrate database:
```cli
rails g scaffold Event date:date datetime:datetime time:time
rake db:migrate
```
<sub>If you're using Bootstrap, make sure to exclude generated `scaffold.css` because it may affect datepicker-styles undesirably. You may also want to add `form-group` to the field element's class</sub>


Add date_picker-helpers to form-view: 
```erb
<%# app/views/events/_form.html.erb %>
<%= form_for(@event) do |f| %>
  <div class="field">
    <%= f.label :date %><br>
    <%= f.date_picker :date %>
  </div>
  <div class="field">
    <%= f.label :datetime %><br>
    <%= f.datetime_picker :datetime %>
  </div>
  <div class="field">
    <%= f.label :time %><br>
    <%= f.time_picker :time %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```


### SimpleForm

Make sure, you added [simple_form](https://github.com/plataformatec/simple_form) to your bundle and have run the install-generator, i.e. `rails g simple_form:install --bootstrap`.

Run date_picker's simple_form-generator in order to create the date_picker-component:
```cli
rails g date_picker:simple_form
```
This will create a custom-input `date_picker`. You may choose a different name by adding it to the command, e.g. `datetime` will override simple_form's default datetime-component.
```cli
rails g date_picker:simple_form date_time
```

Adjust the form to use simple_form-builder:
```erb
<%= simple_form_for(@event) do |f| %>
  <%# ... %>
  <div class="field form-group">
    <%= f.input :date %>
  </div>
  <div class="field form-group">
    <%= f.input :datetime %>
  </div>
  <div class="field form-group">
    <%= f.input :time %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

### Options

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>type</td>
      <td>Data type. One of `:date`, `:datetime` or `:time`</td>
    </tr>
    <tr>
      <td>default</td>
      <td>Specify default date.</td>
    </tr>
    <tr>
      <td>format</td>
      <td>Provide a strftime-pattern or an i18n-identifier.</td>
    </tr>
    <tr>
      <td>max</td>
      <td>Specify maximum date</td>
    </tr>
    <tr>
      <td>min</td>
      <td>Specify minimum date</td>
    </tr>
    <tr>
      <td>time_zone</td>
      <td>Specify whether to include timezone-offset in format. Defaults to `false`.</td>
    </tr>
  </tbody>
</table>

All other options are passed as html-options to text_field-element. All `data-attributes` are passed to the javascript date_picker-implementation. 


## Internationalization

Install `rails-i18n`-gem to get a basic support for many languages.
```
# Gemfile
gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
```

Define date and time formats in yml locale:
```
# config/locales/en.yml
en:
  date:
    formats:
      default: "%Y-%m-%d"
  time:
    formats:
      default: "%a, %d %b %Y %H:%M:%S %z"
      only_time: "%H:%M:%S %z"
```

You may want to change the default i18n-identifier names by editing the configuration:

```rb
# config/initializers/date_picker.rb
DatePicker.configure do |config|
  config.formats = {
    date: :default,
    datetime: :default,
    time: :only_time
  }
end
```

## Mobile
On mobile devices the plugin falls back to date_field-helpers using html5-input-types.


## Changelog
See the [Changelog](CHANGELOG.md) for recent enhancements, bugfixes and deprecations.