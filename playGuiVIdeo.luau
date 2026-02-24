local HttpService = game:GetService("HttpService")

return function(Player, jsonData, FPS)
    local data = type(jsonData) == "string" and HttpService:JSONDecode(jsonData) or jsonData
    local palette = data.Palette
    local resX, resY = data.Res[1], data.Res[2]
    
    local sGui = Instance.new("ScreenGui")
    sGui.Name = "VideoScreenGui" 
    sGui.Parent = Player:WaitForChild("PlayerGui")
    
    local container = Instance.new("Frame")
    container.Size = UDim2.fromScale(.9, .9)
    container.Position = UDim2.fromScale(0.05, 0.05) 
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
    
    print("GUI Screen Ready. Playing Adaptive Video...")

    while true do
        for _, frameData in ipairs(data.Frames) do
            local frameStart = os.clock()
            local method = frameData[1]
            
            if method == 0 then
                -- [ METHOD 0: RAW PALETTE ]
                for i = 2, #frameData do
                    local colorData = palette[frameData[i] + 1]
                    if colorData and pixels[i - 1] then
                        pixels[i - 1].BackgroundColor3 = Color3.fromRGB(colorData[1], colorData[2], colorData[3])
                    end
                end

            elseif method == 1 then
                -- [ METHOD 1: RLE (RUN-LENGTH ENCODING) ]
                local pixelIndex = 1
                for i = 2, #frameData, 2 do
                    local colorData = palette[frameData[i] + 1]
                    local count = frameData[i + 1]
                    
                    if colorData then
                        local c3 = Color3.fromRGB(colorData[1], colorData[2], colorData[3])
                        for j = 1, count do
                            if pixels[pixelIndex] then
                                pixels[pixelIndex].BackgroundColor3 = c3
                            end
                            pixelIndex = pixelIndex + 1
                        end
                    else
                        pixelIndex = pixelIndex + count
                    end
                end

            elseif method == 2 then
                -- [ METHOD 2: DELTA ENCODING ]
                for i = 2, #frameData, 2 do
                    local pixelIndex = frameData[i] + 1
                    local colorData = palette[frameData[i + 1] + 1]
                    
                    if colorData and pixels[pixelIndex] then
                        pixels[pixelIndex].BackgroundColor3 = Color3.fromRGB(colorData[1], colorData[2], colorData[3])
                    end
                end
            end
            
            local elapsed = os.clock() - frameStart
            task.wait(math.max(0, (1/FPS) - elapsed))
        end
        task.wait()
    end
end