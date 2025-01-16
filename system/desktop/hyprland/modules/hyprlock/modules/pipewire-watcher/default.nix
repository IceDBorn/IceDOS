{
  pkgs,
  ...
}:

{
  environment.systemPackages = [
    (pkgs.writeScriptBin "pipewire-watcher" ''
      #!/usr/bin/env wpexec
      local INPUT = "Stream/Input/Audio"
      local OUTPUT = "Stream/Output/Audio"
      local OUTPUTS_TO_IGNORE = {
        'Discord',
        'Element',
      }

      local INPUTS_TO_IGNORE = {
        'Noise Canceling source',
        'Peak detect',
        'cava',
      }

      local INHIBIT_LOCK = false

      local nodeManager = ObjectManager({
        Interest({
          type = "node",
          Constraint({ "media.class", "in-list", OUTPUT, INPUT }),
        }),
      })

      local linkManager = ObjectManager({
        Interest({
          type = "link",
        }),
      })

      local function hasActiveLinks(nodeId, linkType)
        local constraint = Constraint({ linkType, "=", tostring(nodeId) })
        for link in linkManager:iterate({ type = "link", constraint }) do
          if link.state == "active" then
            return true
          end
        end
        return false
      end

      local function hasValue (val, tab)
        for index, value in ipairs(tab) do
            if string.find(val, value) then
                return true
            end
        end
        return false
      end

      nodeManager:connect("installed", function(nodeManager)
        for node in nodeManager:iterate() do
          local mediaName = node.properties["media.name"]
          local mediaClass = node.properties["media.class"]
          local skip = false

          if ((mediaClass == INPUT and hasValue(mediaName, INPUTS_TO_IGNORE)) or (mediaClass == OUTPUT and hasValue(mediaName, OUTPUTS_TO_IGNORE))) then
            skip = true
          end

          if (hasActiveLinks(node.bound_id, "link.input.node") or hasActiveLinks(node.bound_id, "link.output.node")) and skip == false then
            INHIBIT_LOCK = true
            break
          end
        end

        print(INHIBIT_LOCK)
        Core.quit()
      end)

      linkManager:activate()
      nodeManager:activate()
    '')
  ];
}
