-- inputs 
local A = ARGV[1]
local B = ARGV[2]
local C = ARGV[3]
local D = ARGV[4]
local E = ARGV[5]
local F = ARGV[6]

local M = "M"
local P = "P"
local T = "T"
local H = "Err"

-- Base Substitution expressions  

-- A && B && !C => H = M
local bool1evb = "return %s and %s and not %s" 
-- A && B && C => H = P
local bool2evb = "return %s and %s and %s"
-- !A && B && C => H = T
local bool3evb = "return not %s and %s and %s"

local float1evb = "return %d + (%d * %d / 10)" 
local float2evb = "return %d + (%d * (%d - %d )/ 25.5)"
local float3evb = "return %d - (%d *  %d / 30)"

local float_ev1b = float1evb:format(tostring(D),tostring(D),tostring(E))
local float_ev2b = float2evb:format(tostring(D),tostring(D),tostring(E),tostring(F))
local float_ev3b = float3evb:format(tostring(D),tostring(D),tostring(F))

local exp = redis.call("get", "expression")

-- Custom 1 Substitution expressions
if (exp == "Custom 1") then
  float2evb = "return 2 * %d + (%d * %d / 100)" 
-- H = P => K = 2 * D + (D * E / 100)
  float_ev2b = float2evb:format(tostring(D),tostring(D),tostring(E))
end

-- Custom 2 Substitution expressions  
if (exp == "Custom 2") then
-- A && B && !C => H = T
  bool3evb = "return %s and %s and not %s"
--A && !B && C => H = M
  bool2evb = "return %s and not %s and %s"
-- H = M => K = F + D + (D * E / 100)
  float1evb = "return %d + %d + (%d * %d / 100)" 
  float_ev1b = float1evb:format(tostring(F),tostring(D),tostring(D),tostring(E))
end

local bool_ev = bool1evb:format(tostring(A),tostring(B),tostring(C))

local h = redis.call("get", "H")
local r =  H 

if ( h == "M") then 
  r =  loadstring(float_ev1b)()
elseif ( h == "P") then
  r =  loadstring(float_ev2b)()
elseif ( h == "T") then
  r =  loadstring(float_ev3b)()
else
  return H 
end

--return A.." "..B.." "..C.." "..D.." "..E.. " "..D 
--local r =  loadstring(bool_ev)()
return tostring(r)
