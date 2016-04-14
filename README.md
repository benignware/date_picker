# date_picker
> Rails DatePicker-Integration

* Supports bootstrap-datetimepicker and jquery_ui-datepicker
* Seamless i18n-Integration
* FormBuilder- and SimpleForm-Helpers for date, datetime and time-attributes
* HTML5-Fallback on Mobile

## Install

Add the following to your Gemfile:

```cli
gem 'date_picker'
```

The module does not bundle any third-party assets. 
Recommended way to download required client-side-dependencies is by using [bower](http://bower.io). 

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

Bootstrap is supported by the integration of [eonasdan-bootstrap-datetimepicker](https://github.com/Eonasdan/bootstrap-datetimepicker) >= 4.17.37

Run the config-generator using `:bootstrap`
```cli
rails g date_picker:config :bootstrap
```

Install dependencies via bower
```cli
bower install bootstrap --save
bower install eonasdan-bootstrap-datetimepicker --save
```

Require javascript dependencies:
```javascript
// app/assets/javascripts/application.js
//= require moment/min/moment-with-locales.min
//= require moment-timezone/builds/moment-timezone-with-data.min
//= require moment/min/locales.min
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
```

Require css dependencies:
```css
/* app/assets/stylesheets/application.css
 *= require bootstrap/dist/css/bootstrap.min
 *= require eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.min
 */
```

### jQueryUI DatePicker

Also supported is [jquery-ui](https://jqueryui.com/)'s datepicker.

Run the config-generator using `:jquery_ui`
```cli
rails g date_picker:config :jquery_ui
```

Install dependencies via bower
```cli
bower install jquery-ui --save
```

Require javascript dependencies:
```javascript
// app/assets/javascripts/application.js
//= require jquery/dist/jquery.min
//= require jquery-ui/jquery-ui.min
```

Require css dependencies:
```css
/* app/assets/stylesheets/application.css
 *= require jquery-ui/themes/smoothness/jquery-ui.min
 *= require jquery-ui/themes/smoothness/theme
 */
```

## Form helpers

The date_picker-Module provides tag helpers, form-builder helpers and simple_form-helpers for attributes of type `:date`, `:datetime` and `:time`.

> Please note that `jquery-ui` can only handle dates, while `eonasdan-bootstrap-datetimepicker` also supports attributes of type `:datetime` and `:time`. Form helpers will fall back to the corresponding standard-rails date_select-helpers. 

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
      <td>The data-type of the input, e.g. :date</td>
    </tr>
    <tr>
      <td>default</td>
      <td>The default value for the input. Defaults to current</td>
    </tr>
    <tr>
      <td>format</td>
      <td>Provide a strftime-pattern as string or a i18n-identifier as a symbol</td>
    </tr>
    <tr>
      <td>time_zone</td>
      <td>Specifies whether to include timezone-offset in format. Defaults to `false`.</td>
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

By default, the plugin looks for strftime-patterns in the following locations:
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

You may want to change the i18n-identifier names by editing the configuration:

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

``` 
bower install eonasdan-bootstrap-datetimepicker#development --save
```

## Mobile
On mobile devices the plugin falls back to date_field-helpers using html5-input-types.


## Changelog
See the [Changelog](CHANGELOG.md) for recent enhancements, bugfixes and deprecations.