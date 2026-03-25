# eglot-flat

Flat and mergeable workspace configuration support for Eglot.

## Usage

First, put the following in your `init.el`:

```
(setq-default eglot-workspace-configuration #'eglot-flat-workspace-configuration)
```

Then, you can use `eglot-flat-global-workspace-configuration` to set global configuration for all servers:

```elisp
(setopt eglot-flat-global-workspace-configuration
        '(("yaml.format.enable" . t)
          ("yaml.format.printWidth" . 120)))
```

And then, you can use `eglot-flat-project-workspace-configuration` to set project-specific configuration:

```elisp
((nil . ((eglot-flat-project-workspace-configuration . (("yaml.format.singleQuote" . t)
                                                ("yaml.format.printWidth" . 80))))))
```

As a result, the final configuration will be:

```elisp
(:yaml (:format ( :singleQuote t
                  :printWidth 80
                  :enable t)))
```

> [!WARNING]
> You should use `:json-false` to represent json `false` value. Because `nil` means json `null` value.

## License
GPL-3.0
