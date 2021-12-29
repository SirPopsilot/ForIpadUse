local vault = peripheral.wrap("create:item_vault_2") --requires create mod vault
local barrel = peripheral.wrap("minecraft:barrel_0") -- requires a barrel
local monitor = peripheral.find("monitor") --requires a monitor tauching the computer
--both need to be connected to the same network
--monitor size is 3x2 or 29 x 12 chars
--midle point at x = 15
local db = {}
local dbCount = 0
local CorrentScreenName
local MainScreenBB = {} --BB = BindingBoxes , Item Options is index 1 to 5
    

function resetColors()
    monitor.setTextColor(1); monitor.setBackgroundColor(32768)
end

function DoesItemExist(itemDisplayName,database)--function that checks if an item is already in the DataBase based on its displayName
    for name , count  in pairs(database) do
        if name == itemDisplayName then
            return true
        end
    end
    return false
end

function WriteDataBase()--function that adds an item and its count to the DataBase if it doesnt exist other wise adds to its count
    for slot , item in pairs(vault.list()) do
        local itemDisplayName = vault.getItemDetail(slot).displayName
        if DoesItemExist(itemDisplayName,db) then
            db[itemDisplayName] = vault.getItemDetail(slot).count + db[itemDisplayName]
        else
            dbCount = dbCount + 1
            db[itemDisplayName] = item.count
        end
    end
end

function WriteItemInMainScreen(Item , count,IsSelected) --function thats writes the item count and item name in a specific way
    monitor.setTextColor(32768); monitor.setBackgroundColor(8)
    local tempPosX,tempPosY = monitor.getCursorPos()
    monitor.write("   ")
    monitor.setCursorPos(tempPosX,tempPosY)
    if count < 1000 then
        monitor.write(tostring(count))
    else
        monitor.write("999")
    end
    if IsSelected then  
        monitor.setTextColor(32768); monitor.setBackgroundColor(8)
        monitor.setCursorPos(tempPosX+3,tempPosY)
        monitor.write(Item)
    else
        resetColors()
        monitor.setCursorPos(tempPosX+3,tempPosY)
        monitor.write(Item)
    end
    resetColors()
end

function draw_Item_Options(page,selectedItemIndexOnPage) --function that draws the first 5 times in the db for the page
    monitor.setCursorPos(1,3)
    local ItemOnScreenLimitor = 0
    local startingIndex = 1 + 5*(page-1)
    local correntIndex = 1
    for name , count in pairs(db) do
        if correntIndex >= startingIndex then
            ItemOnScreenLimitor = ItemOnScreenLimitor + 1
            if ItemOnScreenLimitor == 5 then break end

            if ItemOnScreenLimitor == selectedItemIndexOnPage then
                WriteItemInMainScreen(name,count,true)
            else
                WriteItemInMainScreen(name,count,false)
            end

            local tempx ,tempy = monitor.getCursorPos()
            monitor.setCursorPos(1,tempy+2)
             
        end
        correntIndex = correntIndex + 1
    end
end

function draw_Empty_button() --function that draws the for the empty barrel button
    monitor.setTextColor(32768);monitor.setBackgroundColor(512)
    monitor.setCursorPos(23,9);monitor.write("       ")
    monitor.setCursorPos(23,10);monitor.write(" Empty>")
    monitor.setCursorPos(23,11);monitor.write("       ")
    resetColors()
end



function clearRightSide()
    monitor.setTextColor(32768);monitor.setBackgroundColor(512)
    for i = 2 ,12,1 do
        monitor.setCursorPos(15,i)
        print("                                             ")
    end
end

function draw_main_screen(page) --function that draws the main screen
    monitor.setCursorPos(8,1)
    monitor.write("Choose an Item")
    draw_Item_Options(page)
    if dbCount > 5 then
        monitor.setCursorPos(1,12)
        monitor.write("[NXT][PRV]")
    end
    clearRightSide()
    draw_Empty_button()
end

function EmptyBarrel() --function that emptys the barrel into the main create mod vault
    for slot , item in pairs(barrel.list()) do
        vault.pullItems(peripheral.getName(barrel),slot)
    end
end



function leftSideActions(xcords,ycords)
    -- body
end

function RightSideActions(xcords,ycords,IsNumpad)
    -- body
end

function TouchDepartment()
    -- body
end

monitor.clear()
monitor.setCursorPos(1,1)
EmptyBarrel()
WriteDataBase()
for k,v in pairs(db) do
    print(k,"x",v)
end
draw_main_screen(1)
resetColors()