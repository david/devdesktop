#!/usr/bin/env nu

export def --wrapped main [
  --cell-size: string
  --font-size: float
  --group: string
  --opacity: float
  --padding: int
  --remote
  ...rest
] {
  (
    kitty
      --override $"window_padding_width=($padding | default 0)"
      --override "forward_stdio=true"
      ...(
        if $opacity != null {
          [ --override dynamic_background_opacity=true --override $"background_opacity=($opacity)" ]
        } else {
          []
        }
      )
      ...(if $font_size != null { [ --override $"font_size=($font_size)" ] } else { [] })
      ...(if $cell_size != null { [--override $"modify_font cell_height ($cell_size)"] } else { [] })
      ...(if $group != null { [--instance-group $group --single-instance] } else { [] })
      ...(if $remote { [--override allow_remote_control=true] } else { [] })
      ...$rest
  )
}

export def "main fz" [...$command] {
  # build the command used to produce the list of items that will be filtered,
  # since I couldn't find a way to have kitty redirect its stdin to a child process
  let cmd = (
    $command
    | append [
      "|" "fz"
      "|" "save" "--raw" "--append" "$\"/dev/fd/($env.KITTY_STDIO_FORWARDED)\""
    ]
    | str join " "
  )

  main --class "filter" --font-size 18 --padding 8 nu --commands $"($cmd)" | str trim
}

export def "main widget" [name: string] {
  (
    main
      # TODO: this should be close to the rest of the configuration in Nix
      --cell-size 140%
      --class $"widget.($name)"
      --detach
      --font-size 16
      --hold
      --padding 0
      --title $"widget.($name)"
      # TODO: remove full path to widget
      nu $"($env.HOME)/.local/share/widgets/widget-($name).nu"
  )
}
