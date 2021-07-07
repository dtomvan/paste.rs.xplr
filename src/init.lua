local function setup(args)
    local xplr = xplr
    xplr.config.modes.custom["paste.rs"] = {
        name = "paste.rs",
        key_bindings = {
            on_key = {
                p = {
                    help = "paste",
                    messages = {
                        {
                            BashExec = [===[
                            PTH=$(basename "${XPLR_FOCUS_PATH:?}")
                            DEST="${XPLR_SESSION_PATH:?}/paste.rs.list"
                            curl --data-binary "@${PTH:?}" "https://paste.rs" | tee -a "${DEST:?}"
                            echo
                            read -p "[enter to continue]"
                            ]===],
                        },
                        "PopMode",
                    },
                },
                l = {
                    help = "list",
                    messages = {
                        {
                            BashExec = [===[
                            cat "${XPLR_SESSION_PATH:?}/paste.rs.list"
                            echo
                            read -p "[enter to continue]"
                            ]===],
                        },
                        "PopMode",
                    },
                },
                o = {
                    help = "search and open",
                    messages = {
                        {
                            BashExec = [===[
                            DEST="${XPLR_SESSION_PATH:?}/paste.rs.list"
                            URL=$(fzf --preview "curl -s '{}'" < "${DEST:?}")
                            if [ "$URL" ]; then
                                OPENER=$(which xdg-open)
                                ${OPENER:-open} "${URL:?}"
                            fi
                            ]===],
                            },
                            "PopMode",
                        },
                    },
                    d = {
                        help = "search and delete",
                        messages = {
                            {
                                BashExec = [===[
                                DEST="${XPLR_SESSION_PATH:?}/paste.rs.list"
                                URL=$(fzf --preview "curl -s '{}'" < "${DEST:?}")
                                if [ "$URL" ]; then
                                    curl -X DELETE "${URL:?}"
                                    sd "${URL:?}\n" "" "${DEST:?}"
                                    echo
                                    read -p "[enter to continue]"
                                fi
                                ]===],
                            },
                                "PopMode",
                            },
                        },
                        esc = {
                            help = "cancel",
                            messages = {
                                "PopMode",
                            }
                        }
                    }
                }
    }
    if args == nil then
        args = {}
    end
    if args.mode == nil then
        args.mode = "default"
    end
    if args.key == nil then
        args.key = "P"
    end
    xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
        help = "paste.rs",
        messages = {
            "PopMode",
            {
                SwitchModeCustom = "paste.rs"
            },
        }
    }
end

return { setup = setup }
