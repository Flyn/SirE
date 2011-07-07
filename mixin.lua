-- a Mixin class
-- Usage:
--  * create a new mixin with methods
--     Closable = Mixin.create()
--     function Closable:close() print('close') end
--  * apply the mixin to a "class" or an instance
--     Closable.mixin(Window)
--     w = Window:create()
--     w:close() --> prints 'close'
--
-- mixin() fails if method names conflict

Mixin = {}

function Mixin:create(mixin) -- type: table
    -- here self = class
    mixin = mixin or {}
    setmetatable(mixin, self)
    self.__index = self
    return mixin
end

function Mixin:mixin(class) -- type: table
    for name, method in pairs(self) do
        if class[name] then
            error("Method "..name.." already exists!", 2)
        else
            class[name] = method
        end
    end
    return class
end