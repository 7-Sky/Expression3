Expression3.Tokenizer.Chunk = {}

Expression3.Tokenizer.Chunk.Stats = {
	[1] = "Valid",
	[2] = "Error",
	[3] = "Timeout",
	[4] = "In Process",
	[5] = "None",
}

Expression3.Tokenizer.Chunk.__index = Expression3.Tokenizer.Chunk

Expression3.Tokenizer.Chunk.Status = Expression3.Tokenizer.Chunk.Stats[5]

function Expression3.Tokenizer.Chunk:ctor()
	self.__hash = string.format("%p", self)
end

function Expression3.Tokenizer.Chunk:dtor()
	
end

function Expression3.Tokenizer.Chunk:__tostring()
	return "E3TokenChunk["..self.__hash.."]"
end

function Expression3.Tokenizer.Chunk:SetSource(objectSource)
	self.objectSource = objectSource
end

function Expression3.Tokenizer.Chunk:GetSource()
	return self.objectSource
end

function Expression3.Tokenizer.Chunk:CreateBranch(newBranch)
	self.Branches[#self.Branches + 1] = newBranch
end

function Expression3.Tokenizer.Chunk:Process(sourceCode)
	self.Status = Expression3.Tokenizer.Logic:Decide(sourceCode)
	if not self.Status then goto Skip end
	if self.Status == "Valid" then
		return true, self.Status
	elseif self.Status == "Error" then
		return self.Status
	end
	::Skip::
	return false, "Timeout"
end

function Expression3.Tokenizer.Chunk:Return()
	return Expression3.Tokenizer.Chunk:Process(self.objectSource)
end

function Expression3.Tokenizer.Chunk:Build(objectSource)
	local newChunk = setmetatable({}, Expression3.Tokenizer.Chunk)
	newChunk:ctor()
	return newChunk
end

local new = Expression3.Tokenizer.Chunk:Build()

new:SetSource([[
	#include <holo>
	#include <matrix>
	var count = 1

	var pos = new Vector // Test Comment!

	var test = new holo
	test->SetPos(pos(10, 0, 0))
]])

print(new:Return())