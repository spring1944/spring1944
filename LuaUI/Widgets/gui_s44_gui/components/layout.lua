local component = {}

function component:Initialize()
  widgetHandler:ConfigLayoutHandler(false)
end

function component:Shutdown()
  widgetHandler:ConfigLayoutHandler(true)
end

return component
