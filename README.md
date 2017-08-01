# erb_asterisk

This gem is add ability to declare asterisk configuration with ERB files.

## Installation

    $ gem install erb_asterisk

## Usage

### Create ERB configuration files and templates
```
├── asterisk
...
│   ├── entities
│   │   ├── office
│   │   │   ├── pjsip_endpoints.conf
│   │   │   └── pjsip_endpoints.conf.erb
│   │   ├── taxi
│   │   │   ├── pjsip_endpoints.conf
│   │   │   ├── pjsip_endpoints.conf.erb
│   │   │   ├── queues.conf
│   │   │   └── queues.conf.erb
...
│   ├── pjsip_endpoints.conf
│   ├── pjsip_endpoints.conf.includes
...
│   ├── queues.conf
│   ├── queues.conf.includes
...
│   ├── templates
│   │   ├── pjsip_operators.erb
│   │   └── queues.erb
```

### Templates

Templates can be defined only in `asterisk/templates` directory.

pjsip_operators.erb:
```
[<%= op %>](operator)
auth=<%= op %>
aors=<%= op %>
set_var=GROUP()=operator<%= op %>
[<%= op %>](operator-auth)
username=<%= op %>
[<%= op %>](aor-single-reg)
<% end %>
```

queues.erb:
```
[operators-<%= name %>]
strategy = rrmemory
joinempty = yes
musicclass = queue
<% members.times.each do |i| %>
<% op = offset + i %>
<% group = 100 + i %>
member => Local/<%= "#{group}#{op}" %>@queue-dial-control,0,,SIP/<%= op %>
<% end %>
ringinuse = no
announce-frequency = 30
announce-holdtime = no
retry = 0
```

### ERB configuration

Rendering template:
```
<%= render 'template_file_name_without_ext', variable_name: variable_value %>
```

Define inclusion (asterisk `#include` command) to external configuration file:
```
<%= include_to 'pjsip_endpoints.conf.includes' %>
```
This will create (overwrite) file pjsip_endpoints.conf.includes with `#include` command of current processed erb file. For example:

pjsip_endpoints.conf.includes:
```
#include "entities/office/pjsip_endpoints.conf"
#include "entities/taxi/pjsip_endpoints.conf"
...
```

You can include this file to your actual pjsip_endpoints.conf.

entities/office/pjsip_endpoints.conf.erb:
```
<%= include_to 'pjsip_endpoints.conf.includes' %>
<%= 15.times.each do |i| %>
<%= render 'pjsip_operators', op: 100 + i %>
<% end %>
```

entities/taxi/pjsip_endpoints.conf.erb:
```
<%= include_to 'pjsip_endpoints.conf.includes' %>
<%= 5.times.each do |i| %>
<%= render 'pjsip_operators', op: 200 + i %>
<% end %>
```

Global variables:

Project avaliable global variables can be defined inside file `erb_asterisk_project.rb`, e.g.:
```
OPERATORS_SIZE = 31
```

### Run erb_asterisk

    $ cd /etc/asterisk
    $ erb_asterisk
