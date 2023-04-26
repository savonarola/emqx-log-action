# EMQX Log Action Plugin

A simple log action for EMQX Rule Engine.

To use:

* Build the plugin
```bash
make rel
```
* Install the plugin: https://www.emqx.io/docs/en/v5.0/extensions/plugins.html#develop-emqx-plugins
* Enable the plugin on the EMQX dashboard
* Create a rule with the log action
```
rule_engine {
  rules {
    "rule_21y9" {
      actions = [
        {
          args {level = "warning"}
          function = "emqx_log_action:log"
        }
      ]
      description = ""
      enable = true
      sql = "SELECT\n  *\nFROM\n  \"t/#\""
    }
  }
}

```
