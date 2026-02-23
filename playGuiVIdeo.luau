
local HttpService = game:GetService("HttpService")

return function(Player, jsonData)
    local data = type(jsonData) == "string" and HttpService:JSONDecode(jsonData) or jsonData
    local palette = data.Palette
    local resX, resY = data.Res[1], data.Res[2]
    
    local sGui = Instance.new("ScreenGui")
    sGui.Parent = Player:WaitForChild("PlayerGui")
    
    local container = Instance.new("Frame")
    container.Size = UDim2.fromScale(1, 1)
    container.BackgroundTransparency = 1
    container.Parent = sGui
    
    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.fromScale(1/resX, 1/resY)
    grid.CellPadding = UDim2.fromOffset(0, 0)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = container
    
    local pixels = {}
    for i = 1, (resX * resY) do
        local f = Instance.new("Frame")
        f.BorderSizePixel = 0
        f.LayoutOrder = i
        f.Parent = container
        pixels[i] = f
    end
    
    print("GUI Screen Ready. Playing...")

    while true do
        for _, frameIndices in ipairs(data.Frames) do
            local frameStart = os.clock()
            
            for i, paletteIndex in ipairs(frameIndices) do
                local colorData = palette[paletteIndex + 1]
                if colorData then
                    pixels[i].BackgroundColor3 = Color3.new(colorData[1], colorData[2], colorData[3])
                end
            end
            
            local elapsed = os.clock() - frameStart
            task.wait(math.max(0, (1/24) - elapsed))
        end
    end
end
