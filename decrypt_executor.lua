local base64_charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function base64_decode(data)
    data = string.gsub(data, '[^'..base64_charset..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (base64_charset:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2^(8 - i) or 0)
        end
        return string.char(c)
    end))
end

function bxor(a, b)
    local res = 0
    for i = 0, 7 do
        local x = a % 2
        local y = b % 2
        if x ~= y then res = res + 2^i end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
    end
    return res
end

function xor_decrypt(data, key)
    local result = {}
    for i = 1, #data do
        local byte = string.byte(data, i)
        local keyByte = string.byte(key, ((i - 1) % #key) + 1)
        table.insert(result, string.char(bxor(byte, keyByte)))
    end
    return table.concat(result)
end

local diffs = { 97, 13, -7, -2, 7, -9, 12, -11, 1, 8, 2, -1, 6, -19, 13, -13 }

local function decodeDiffs(diffs)
    local result = {}
    local prev = 0
    for i = 1, #diffs do
        local val = diffs[i] + prev
        table.insert(result, val)
        prev = val
    end
    return result
end

local function bytesToString(bytes)
    local str = ""
    for i = 1, #bytes do
        local c = string.char(bytes[i])
        if bytes[i] < 32 or bytes[i] > 126 then
            error("Unauthorized byte access")
        end
        str = str .. c
    end
    return str
end

local function getKey(secret)
    if secret ~= "authorized_call" then return nil end
    local key_bytes = decodeDiffs(diffs)
    return bytesToString(key_bytes)
end

local key = getKey("authorized_call")

local base64 = [[
-- encrypted.txt içeriği buraya gelecek
]]

local encrypted = base64_decode(base64)
local decrypted = xor_decrypt(encrypted, key)

local func, err = loadstring(decrypted)
if not func then
    outputServerLog("ERROR: " .. tostring(err))
else
    func()
end
