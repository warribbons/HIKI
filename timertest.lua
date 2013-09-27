foo = ""
stime = love.timer.getTime()

for i=1,1000 do
    foo = foo .. "bar"
end

etime = love.timer.getTime()
print("It took " .. (etime-stime) .. " to concatenate 'bar' 1000 times!")