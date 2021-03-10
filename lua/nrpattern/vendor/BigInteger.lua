-- Source: https://github.com/A-Benlolo/BigInteger.lua/blob/master/BigInteger.lua
--A BigInteger class for arbitrarily long integers
--Works well for integers up to ~3000 digits, but is somewhat slow beyond that
--Credit (Please don't remove): Alexander Benlolo ... November 27, 2019 ... abenlo1@students.towson.edu
local BigInteger = {}
local mt = {__index = BigInteger}

--Convert a BigInteger to any base string up to 36
local function decimalToNewBase(num, b)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Invalid number.")
  assert(type(b)=="table" and b.value~=nil and b.sign~=nil and b:greaterThan(BigInteger.ONE()), "Invalid base.")

  local k, out, pos="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ", ""
  local temp=BigInteger:new(num:toString(), '+')
  local zero, one=BigInteger.ZERO(), BigInteger.ONE()
  while temp:greaterThan(zero) do
    temp, pos = temp:divide(b)
    pos=pos:add(one)
    out=string.sub(k, tonumber(pos:toString()), tonumber(pos:toString())) .. out
  end
  return out
end

--Convert any base string up to 36 to a decimal string
local function anyBaseToDecimal(num, b)
  assert(type(num)=="string", "Invalid number.")
  assert(type(b)=="number" and b>1, "Invalid base.")

  local base=BigInteger:new(tostring(b), '+')
  local sum=BigInteger.ZERO()
  local digit=string.upper(num)
  local i, one=BigInteger.ONE(), BigInteger.ONE()
  local length=BigInteger:new(tostring(string.len(digit)), '+')
  local c, pos, newNum

  while i:lessThanOrEqualTo(length) do
    pos=tonumber(length:subtract(i):add(BigInteger.ONE()):toString())
    c=string.sub(digit, pos, pos)
    if c=="A" then newNum=BigInteger:new("10", '+')
    elseif c=="B" then newNum=BigInteger:new("11", '+')
    elseif c=="C" then newNum=BigInteger:new("12", '+')
    elseif c=="D" then newNum=BigInteger:new("13", '+')
    elseif c=="E" then newNum=BigInteger:new("14", '+')
    elseif c=="F" then newNum=BigInteger:new("15", '+')
    elseif c=="G" then newNum=BigInteger:new("16", '+')
    elseif c=="H" then newNum=BigInteger:new("17", '+')
    elseif c=="I" then newNum=BigInteger:new("18", '+')
    elseif c=="J" then newNum=BigInteger:new("19", '+')
    elseif c=="K" then newNum=BigInteger:new("20", '+')
    elseif c=="L" then newNum=BigInteger:new("21", '+')
    elseif c=="M" then newNum=BigInteger:new("22", '+')
    elseif c=="N" then newNum=BigInteger:new("23", '+')
    elseif c=="O" then newNum=BigInteger:new("24", '+')
    elseif c=="P" then newNum=BigInteger:new("25", '+')
    elseif c=="Q" then newNum=BigInteger:new("26", '+')
    elseif c=="R" then newNum=BigInteger:new("27", '+')
    elseif c=="S" then newNum=BigInteger:new("28", '+')
    elseif c=="T" then newNum=BigInteger:new("29", '+')
    elseif c=="U" then newNum=BigInteger:new("30", '+')
    elseif c=="V" then newNum=BigInteger:new("31", '+')
    elseif c=="W" then newNum=BigInteger:new("32", '+')
    elseif c=="X" then newNum=BigInteger:new("33", '+')
    elseif c=="Y" then newNum=BigInteger:new("34", '+')
    elseif c=="Z" then newNum=BigInteger:new("35", '+')
    else newNum=BigInteger:new(c, '+') end
    sum=sum:add(newNum:multiply(base:pow(i:subtract(one))))
    i=i:add(one)
  end

  return sum:toString()
end

--Convert a string of numbers to a table
local function stringToTable(num)
  assert(type(num)=="string", "Invalid value: " .. num .. " is not a string.")
  local temp={}
  local length=string.len(num)
  for i=1, length do
    if string.sub(num, i, i) ~= '-' then
      temp[length-i+1]=tonumber(string.sub(num, i, i))
    end
  end
  return temp
end

--Remove any trailing zeroes from a BigInteger
local function removeTrailingZeroes(big)
  for i=#big.value, 1, -1 do
    if big.value[i]==0 then table.remove(big.value, i)
    else break end
  end
  if big:toString()=="" then big.value={0} end
end

--Create a new BigInteger
function BigInteger:new(num, s, base)
  assert(num~=nil and type(num)=="string", "Invalid value: " .. num .. " is not a string.")
  assert(s~=nil and type(s)=="string" and (s == '+' or s == '-'), "Invalid sign.") 
  assert(base==nil or (type(base)=="number" and base>1 and base<=36), "Invalid base.")

  --Convert from the proper base to decimal
  if base~=nil and base~=10 then num=anyBaseToDecimal(num, base) end

  return setmetatable({
      value=stringToTable(num),
      sign=s
    },
    mt
  )
end

--Easy to create BigIntegers
function BigInteger.ZERO() return BigInteger:new("0", '+') end
function BigInteger.ONE() return BigInteger:new("1", '+') end
function BigInteger.TWO() return BigInteger:new("2", '+') end
function BigInteger.THREE() return BigInteger:new("3", '+') end
function BigInteger.FOUR() return BigInteger:new("4", '+') end
function BigInteger.FIVE() return BigInteger:new("5", '+') end
function BigInteger.SIX() return BigInteger:new("6", '+') end
function BigInteger.SEVEN() return BigInteger:new("7", '+') end
function BigInteger.EIGHT() return BigInteger:new("8", '+') end
function BigInteger.NINE() return BigInteger:new("9", '+') end
function BigInteger.TEN() return BigInteger:new("10", '+') end

--Class constants
local ZERO=BigInteger.ZERO()
local ONE=BigInteger.ONE()
local TWO=BigInteger.TWO()
local THREE=BigInteger.THREE()
local FOUR=BigInteger.FOUR()
local FIVE=BigInteger.FIVE()
local SIX=BigInteger.SIX()
local SEVEN=BigInteger.SEVEN()
local EIGHT=BigInteger.EIGHT()
local NINE=BigInteger.NINE()
local TEN=BigInteger.TEN()


--Set the value of this BigInteger
function BigInteger:setValue(num)
  assert(type(num)=="string", "Invalid value: ", num, " is not a string.")
  self.value=stringToTable(num)
end

--Set the sign of this BigInteger
function BigInteger:setSign(s)
  assert(type(s)=="string" and (s == '+' or s == '-'), "Invalid sign: " .. s .. " is not +/-")
  self.sign=s
end

--Return the value of this BigInteger
function BigInteger:getValue()
  return self:toString()
end

--Return the sign of this BigInteger
function BigInteger:getSign()
  return self.sign
end

--Determine if a BigInteger is bigger than this BigInteger
function BigInteger:greaterThan(num)
  --Try to determine based on the sign
  if self.sign=='-' and num.sign=='+' then return false end

  --Try to determine based on length of the number
  if #self.value > #num.value then return true
  elseif #self.value < #num.value then return false end

  --Try to determine based on the digit from most to least significant
  if self.sign=='+' then
    for i=#num.value, 1, -1 do
      if self.value[i]>num.value[i] then return true
      elseif self.value[i]<num.value[i] then return false end
    end
  else
    for i=#num.value, 1, -1 do
      if self.value[i]<num.value[i] then return true
      elseif self.value[i]>num.value[i] then return false end
    end
  end

  --If you got this far then the numbers are equal
  return false
end

--Determine if a BigInteger is smaller than this BigInteger
function BigInteger:lessThan(num)
  --Try to determine based on sign
  if self.sign=='-' and num.sign=='+' then return true end

  --Try to determine based on length
  if #self.value > #num.value then return false
  elseif #self.value < #num.value then return true end

  --Try to determine based on the digit from most to least significant
  if self.sign=='+' then
    for i=#num.value, 1, -1 do
      if self.value[i]>num.value[i] then return false
      elseif self.value[i]<num.value[i] then return true end
    end
  else
    for i=#num.value, 1, -1 do
      if self.value[i]<num.value[i] then return false
      elseif self.value[i]>num.value[i] then return true end
    end
  end

  --If you got this far then the numbers are equal
  return false
end

--Determine if two BigIntegers are equal
function BigInteger:equals(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to compare with " .. self:toString() .. ".")
  if self.sign~=num.sign then return false end
  if #self.value~=#num.value then return false end
  for i=1, #self.value do
    if self.value[i]~=num.value[i] then return false end
  end
  return true
end

--Determine if a BigInteger is greater than or equal to this BigInteger
function BigInteger:greaterThanOrEqualTo(num)
  return not self:lessThan(num)
end

--Determine if a BigInteger is less than or equal to this BigInteger
function BigInteger:lessThanOrEqualTo(num)
  return not self:greaterThan(num)
end

--Add two BigIntegers
function BigInteger:add(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to add  to " .. self:toString() .. ".")

  --The temporary data
  local sum=BigInteger.ZERO()
  local carry=false
  local length=#self.value

  --Do subtraction if only one number is negative
  if self.sign=='+' and num.sign=='-' then 
    sum.value=num.value
    sum.sign='+'
    return self:subtract(sum)
  elseif self.sign=='-' and num.sign=='+' then 
    sum.value=self.value
    sum.sign='+'
    return num:subtract(sum)
  end

  --Determine the length of the shorter number
  if #num.value<length then length=#num.value end

  --Add the number places that are in both values
  for i=1, length do
    sum.value[i]=self.value[i]+num.value[i]
    if carry then sum.value[i]=sum.value[i]+1 ; carry=false end
    if sum.value[i]>=10 then carry=true ; sum.value[i]=sum.value[i]-10 end
  end

  --Append the number places that only one number has
  if #self.value > #num.value then
    for i=#self.value, #sum.value+1, -1 do sum.value[i]=self.value[i] end
  elseif #num.value > #self.value then
    for i=#num.value, #sum.value+1, -1 do sum.value[i]=num.value[i] end
  end

  --Carry the 1 to the appended part as necessary
  while carry do
    length=length+1
    if sum.value[length]~=nil then
      sum.value[length]=sum.value[length]+1
      if sum.value[length]>=10 then sum.value[length]=sum.value[length]-10
      else carry=false end
    else
      sum.value[length]=1
      carry=false
    end
  end

  --Change the sign of sum to negaive if the both numbers added are negative
  if self.sign=='-' and num.sign=='-' then sum:setSign('-') end

  --Remove any trailing zeroes
  removeTrailingZeroes(sum)

  return sum
end

--Subtract one BigInteger from another
function BigInteger:subtract(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to subtract from " .. self:toString() .. ".")
  local diff=BigInteger.ZERO()
  local carry=false
  local length=#num.value

  --If doing other than a positive minus a postive, then simplify
  if self.sign=='+' and num.sign=='-' then
    diff:setSign('+')
    diff:setValue(num:toString())
    return self:add(diff)
  elseif self.sign=='-' and num.sign=='+' then
    diff:setSign('-')
    diff:setValue(num:toString())
    return self:add(diff)
  elseif self.sign=='-' and num.sign=='-' then
    diff:setSign('+')
    diff:setValue(num:toString())
    return self:add(diff)
  end

  --If result will be negative, then swap the numbers, subtract, then change sign to negative
  if num:greaterThan(self) then
    local diff=num:subtract(self)
    diff:setSign('-')
    return diff
  end

  --Subtract the number places that are in both values
  for i=1, #num.value do
    diff.value[i]=self.value[i]-num.value[i]
    if carry then diff.value[i]=diff.value[i]-1 ; carry=false end
    if diff.value[i]<0 then carry=true ; diff.value[i]=diff.value[i]+10 end
  end

  --Append the number places that are only in self, if any
  for i=#self.value, #num.value+1, -1 do
    diff.value[#diff.value+1]=self.value[#diff.value+1]
  end

  --Carry the 1 from the appended part as necessary
  while carry do
    length=length+1
    diff.value[length]=diff.value[length]-1
    if diff.value[length]<0 then diff.value[length]=diff.value[length]+10 
    else carry=false end
  end

  removeTrailingZeroes(diff)

  return diff
end

--Multiply two BigIntegers together
function BigInteger:multiply(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to multiply " .. self:toString() .. ".")

  local prod=BigInteger.ZERO()
  local workingString=""
  local carry=0
  local signS, signN=self.sign, num.sign
  self.sign, num.sign='+', '+'
  --For every digit of num
  for i=1, #num.value do
    --Initialize curr
    local curr=BigInteger:new(workingString, '+')
    --Multiply it with the every number place of self
    for j=1, #self.value do
      --Do the multiplication
      curr.value[#curr.value+1]=num.value[i]*self.value[j]
      --Deal with carry
      if carry~=0 then 
        curr.value[#curr.value]=curr.value[#curr.value]+carry
        carry=0
      end
      if curr.value[#curr.value]>=10 then
        carry=math.floor((curr.value[#curr.value]-(curr.value[#curr.value]%10))/10)
        curr.value[#curr.value]=curr.value[#curr.value]%10
      end
    end
    --Add a number place due to the carry if necessary
    if carry~=0 then
      curr.value[#curr.value+1]=carry
      carry=0
    end
    --Do the addition and update the amount of zeroes
    prod=prod:add(curr)
    workingString=workingString .. "0"
  end

  --Change the signs back to the original
  self.sign=signS
  num.sign=signN

  --Give the product the proper sign
  if self.sign~=num.sign then prod.sign='-'
  else prod.sign='+' end

  return prod
end

--Divide this BigInteger by another BigInteger
function BigInteger:divide(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil and (not num:equals(ZERO)), "Failed to divide " .. self:toString() .. ".")
  local q, r=BigInteger:new("", '+'), BigInteger:new(self:toString(), '+')
  local numPlace=#self.value
  local workingVal=BigInteger:new(tostring(self.value[numPlace]), '+')
  local i=0
  local signS, signN=self.sign, num.sign

  if num:greaterThan(self) then q=BigInteger.ZERO() ; return q, r end

  self.sign, num.sign='+', '+'

  --Do integer division
  while numPlace>0 do
    --Reset the data
    i=0

    --Check how many times num goes into workingVal
    while workingVal:greaterThan(num) or workingVal:equals(num) do
      workingVal=workingVal:subtract(num)
      i=i+1
    end

    --Append i to q
    table.insert(q.value, 1, i)

    --Append the next numPlace onto workingValue
    numPlace=numPlace-1
    if self.value[numPlace]~=nil then
      table.insert(workingVal.value, 1, self.value[numPlace])
      removeTrailingZeroes(workingVal)
    end
  end

  --Calculate the remainder
  r=self:subtract(q:multiply(num))

  --Remove any trailing zeroes
  removeTrailingZeroes(q)
  removeTrailingZeroes(r)

  --Fix the signs
  self.sign=signS
  num.sign=signN
  if self.sign~=num.sign then q.sign='-'
  else q.sign='+' end

  return q, r
end

--Determine this BigInteger modulus another BigInteger
function BigInteger:mod(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil and num.sign=='+', "Failed to modulo " .. self:toString() .. ".")

  local temp=BigInteger:new(self:getValue(), self.sign)

  --If self is negative, then keep adding num until it's positive, then return
  if self.sign=='-' then
    while temp.sign=='-' do temp=temp:add(num) end
    return temp
  end

  --Get the remainder after division
  local q, r=self:divide(num)

  return r

end

--Determine this BigInteger to the power of another BigInteger
function BigInteger:pow(num)
  assert((type(num)=="number" and num>=0) or (type(num)=="table" and num.value~=nil and num.sign~=nil and (num:greaterThan(BigInteger.ZERO()) or num:equals(BigInteger.ZERO()))), "Failed to power " .. self:toString() .. ".")

  if self:equals(BigInteger.ZERO()) then return BigInteger.ZERO() end

  --The working data
  local raised=BigInteger.ONE()
  local i

  --Do the repeated multiplication and correct the sign
  if type(num)=="table" then
    i=BigInteger.ONE()
    while not i:greaterThan(num) do raised=raised:multiply(self) ; i=i:add(ONE) end
    if self.sign=='-' and num:mod(TWO):equals(ONE) then raised.sign='-' end
  else
    i=1
    while i<=num do raised=raised:multiply(self) ; i=i+1 end
    if self.sign=='-' and num%2==1 then raised.sign='-' end
  end

  return raised
end

--Determine this BigInteger to the power of another BigInteger modulo a different BigInteger
function BigInteger:modPow(p, m)
  assert(type(p)=="table" and p.value~=nil and p.sign~=nil and (p:greaterThan(BigInteger.ZERO()) or p:equals(BigInteger.ZERO())), "Invalid power to mod-pow " .. self:toString() .. ".")
  assert(type(m)=="table" and m.value~=nil and m.sign~=nil, "Invalid modulo to mod-pow " .. self:toString() .. ".")

  local counter=BigInteger.ONE()
  local power=BigInteger.ONE()
  local ans=BigInteger.ONE()
  local rest=BigInteger.ONE()
  local workingPower=BigInteger:new(p:toString(), '+')
  local values, binary={self}, {}
  local swapSign=false

  --Find all the powers of two
  while not power:greaterThan(p) do
    table.insert(values, values[#values]:pow(TWO):mod(m))
    power=TWO:pow(counter)
    counter=counter:add(ONE)
  end

  --Remove the last value, because it's one to high
  table.remove(values, #values)

  --Determine the binary representation of p
  while workingPower:greaterThan(ZERO) do
    rest=workingPower:mod(TWO)
    if rest:equals(ZERO) then binary[#binary+1]=0
    else binary[#binary+1]=1 end
    workingPower=workingPower:subtract(rest)
    workingPower=workingPower:divide(TWO)
  end

  --Swap the sign to positive as to not mess up the modulus
  if m.sign=='-' then swapSign=true ; m.sign='+' end

  --Use the binary to determine the final number
  for i=1, #binary do
    if binary[i]==1 then ans=ans:multiply(values[i]):mod(m) end
  end

  --Swap the sign back to negative for the mod and ans
  if swapSign then m.sign='-' ; ans.sign='-' end

  return ans

end

--Generate a random BigInteger 0 < rand < self
function BigInteger:random()
  assert(self.sign=='+', "Max for random number must be positive.")
  --Prepare the random number generation
  math.randomseed(os.time())
  math.random(); math.random(); math.random();

  local rand=BigInteger.ZERO()

  --Generate a random number the same length as self
  for i=1, #self.value do
    rand.value[i]=math.random(10)-1
  end

  --Make the random number 0 < rand < self
  rand=rand:mod(self)
  if rand:equals(ZERO) then rand=BigInteger.ONE() end

  --Remove any trailing zeroes
  removeTrailingZeroes(rand)

  return rand
end

--Get the absolute value of this BigInteger
function BigInteger:abs()
  return BigInteger:new(self:getValue(), '+')
end

--Determine the maximum value between two BigIntegers
function BigInteger:max(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to compare with " .. self:toString() .. ".")
  if self:greaterThan(num) then return BigInteger:new(self:getValue(), self.sign) end
  return BigInteger:new(num:getValue(), num.sign)
end

--Return the minimum value between two BigIntegers
function BigInteger:min(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to compare with " .. self:toString() .. ".")
  if self:lessThan(num) then return BigInteger:new(self:getValue(), self.sign) end
  return BigInteger:new(num:getValue(), num.sign)
end

--Return this BigInteger with a swapped sign
function BigInteger:negate()
  if self.sign=='-' then return BigInteger:new(self:getValue(), '+') end
  return BigInteger:new(self:getValue(), '-')
end

--Return the results from the extended Euclidean algorithim
function BigInteger:euclidean(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to Euclidiate " .. self:toString() .. ".")

  --The working data
  local x0, x1 = BigInteger.ONE(), BigInteger.ZERO()
  local y0, y1 = BigInteger.ZERO(), BigInteger.ONE()
  local a, b

  --Choose the correct a and b based on the values given
  if self:greaterThan(num) then
    a=BigInteger:new(self:toString(), self.sign)
    b=BigInteger:new(num:toString(), num.sign)
  else
    a=BigInteger:new(num:toString(), num.sign)
    b=BigInteger:new(self:toString(), self.sign)
  end

  --The extended Euclidean algorithim
  repeat
    local q, r = a:divide(b)
    local xn=((q:negate()):multiply(x1)):add(x0)
    local yn=((q:negate()):multiply(y1)):add(y0)
    a=BigInteger:new(b:toString(), b.sign)
    x0=BigInteger:new(x1:toString(), x1.sign)
    y0=BigInteger:new(y1:toString(), y1.sign)
    if not r:equals(ZERO) then
      b=BigInteger:new(r:toString(), r.sign)
      x1=BigInteger:new(xn:toString(), xn.sign)
      y1=BigInteger:new(yn:toString(), yn.sign)
    end
  until(r:equals(ZERO))

  return b, x1, y1
end

--Return the multiplicative inverse of self modulo num
function BigInteger:inverse(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil, "Failed to find inverse of " .. self:toString() .. ".")

  local gcd, s, t=self:euclidean(num)

  if self:greaterThan(num) then
    return s:mod(num)
  end
  return t:mod(num)
end

--Use the Miller-Rabin test to determine if a number is probably prime
function BigInteger:isProbablePrime(certainty)
  --Return true if the number=2, 3, 5
  if self:equals(TWO) or self:equals(THREE) or self:equals(FIVE) then return true end

  --Ensure the number is not divisible by 2
  if self.value[1]%2==0 then return false end

  --Ensure the number is not divisible by 3
  local sumOfDigits, length=0, 0
  local sumString=""
  for i=1, #self.value do
    sumOfDigits=sumOfDigits+self.value[i]
  end
  while sumOfDigits>=10 do
    sumString=tostring(sumOfDigits)
    sumOfDigits=0
    length=string.len(sumString)
    for i=1, length do
      sumOfDigits=sumOfDigits+tonumber(string.sub(sumString, i, i))
    end
  end
  if sumOfDigits%3==0 then return false end

  --Ensure the number is not divisible by 5
  if self.value[1]==0 or self.value[1]==5 then return false end

  --All the working data
  local temp=self:subtract(ONE)
  local nMinus=self:subtract(ONE)
  local exp, m, k, j=BigInteger.ZERO(), BigInteger.ZERO(), BigInteger.ZERO(), BigInteger.ONE()
  local a, bBack, bNow

  --Determine k and m for n-1=(2^k)*m
  while not(temp:equals(ONE)) do
    temp=temp:divide(TWO)
    exp=exp:add(ONE)
    if nMinus:mod(TWO:pow(exp)):equals(ZERO) then
      k=BigInteger:new(exp:toString(), '+')
      m=nMinus:divide(TWO:pow(exp))
    end
  end

  a=BigInteger.ONE()
  for i=1, certainty do
    --Change the a
    a=a:add(ONE)

    if a:greaterThanOrEqualTo(nMinus) then a=nMinus:random() end

    --Calculate the original b values
    bBack=a:modPow(m, self)
    if bBack:equals(ONE) or bBack:equals(nMinus) then return true end

    --Calculate the remaining b values
    while j:lessThanOrEqualTo(k) do
      bNow=bBack:modPow(TWO, self)
      --If the b value is -1 (mod n) then n is prime
      if bNow:equals(nMinus) then return true end
      --Else compute the next b value
      bBack=BigInteger:new(bNow:toString(), '+')
      j=j:add(ONE)
    end
  end
  return false
end

--Shift a BigInteger to the left bitwise
function BigInteger:shiftLeft(positions)
  assert(type(positions)=="number" and positions>0 and positions==math.floor(positions), "Failed to shift "..self:toString().." left.")

  local temp=BigInteger:new(self:getValue(), set.sign)

  for i=1, positions do temp=temp:multiply(TWO) end

  return temp
end

--Shift a BigInteger to the right bitwise
function BigInteger:shiftRight(positions)
  assert(type(positions)=="number" and positions>0 and positions==math.floor(positions), "Failed to shift "..self:toString().." right.")

  local temp=BigInteger:new(self:getValue(), set.sign)

  for i=1, positions do temp=temp:divide(TWO) end

  return temp
end

--Return self and num bitwise
function BigInteger:bitwiseAnd(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil and num.sign=='+', "Invalid bitwise and " .. self:toString() .. ".")
  local selfString, numString=self:toString(2), num:toString(2)
  local selfLength, numLength=string.len(selfString), string.len(numString)
  local currSelf, currNum=0, 0

  local length=math.min(selfLength, numLength)
  local tempString=""

  for i=1, length do
    currSelf=tonumber(string.sub(selfString, selfLength-i+1, selfLength-i+1))
    currNum=tonumber(string.sub(numString, numLength-i+1, numLength-i+1))
    if currSelf==1 and currNum==1 then tempString="1"..tempString else tempString="0"..tempString end
  end

  return BigInteger:new(tempString, '+', 2)
end

--Return self or num bitwise
function BigInteger:bitwiseOr(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil and num.sign=='+', "Invalid bitwise and " .. self:toString() .. ".")
  local selfString, numString=self:toString(2), num:toString(2)
  local selfLength, numLength=string.len(selfString), string.len(numString)
  local currSelf, currNum=0, 0

  local length=math.min(selfLength, numLength)
  local tempString=""

  --Compare both strings
  for i=1, length do
    currSelf=tonumber(string.sub(selfString, selfLength-i+1, selfLength-i+1))
    currNum=tonumber(string.sub(numString, numLength-i+1, numLength-i+1))
    if currSelf==1 or currNum==1 then tempString="1"..tempString else tempString="0"..tempString end
  end

  --Add the additional 1 and 0 from a longer string if necessary
  for i=length+1, selfLength do
    currSelf=tonumber(string.sub(selfString, selfLength-i+1, selfLength-i+1))
    if currSelf==1 then tempString="1"..tempString else tempString="0"..tempString end
  end
  for i=length+1, numLength do
    currNum=tonumber(string.sub(numString, numLength-i+1, numLength-i+1))
    if currNum==1 then tempString="1"..tempString else tempString="0"..tempString end
  end


  return BigInteger:new(tempString, '+', 2)
end

--Return self xor bitwise
function BigInteger:bitwiseXor(num)
  assert(type(num)=="table" and num.value~=nil and num.sign~=nil and num.sign=='+', "Invalid bitwise and " .. self:toString() .. ".")
  local selfString, numString=self:toString(2), num:toString(2)
  local selfLength, numLength=string.len(selfString), string.len(numString)
  local currSelf, currNum=0, 0

  local length=math.min(selfLength, numLength)
  local tempString=""

  --Compare both strings
  for i=1, length do
    currSelf=tonumber(string.sub(selfString, selfLength-i+1, selfLength-i+1))
    currNum=tonumber(string.sub(numString, numLength-i+1, numLength-i+1))
    tempString=tostring((currSelf+currNum)%2)..tempString
  end

  --Add the additional 1 and 0 from a longer string if necessary
  for i=length+1, selfLength do
    currSelf=tonumber(string.sub(selfString, selfLength-i+1, selfLength-i+1))
    if currSelf==1 then tempString="1"..tempString else tempString="0"..tempString end
  end
  for i=length+1, numLength do
    currNum=tonumber(string.sub(numString, numLength-i+1, numLength-i+1))
    if currNum==1 then tempString="1"..tempString else tempString="0"..tempString end
  end


  return BigInteger:new(tempString, '+', 2)
end

--Return the BigInteger as a string
function BigInteger:toString(base)
  assert(base==nil or (type(base)=="number" and base>1 and base<=36), "Invalid base")
  local asString=""

  --Convert the table into a string in the proper base
  if base==nil or base==10 then
    for i=#self.value, 1, -1 do asString=asString .. self.value[i] end
  else
    asString=decimalToNewBase(self, BigInteger:new(tostring(base), '+'))
  end

  --Return the string either with no sign or a negative sign
  if self.sign == '-' then

    --Change to two's compliments
    if base==2 then
      local length = string.len(asString)
      local temp=""

      --Flip the bits
      for i=1, length do
        if string.sub(asString, i ,i)=="1" then temp=temp.."0"
        else temp=temp.."1" end
      end

      --Convert to BigInteger to add one
      temp=BigInteger:new(temp, '+', 2)
      temp=temp:add(ONE)

      return temp:toString(2)

      --Or just return it with a negative sign
    else
      return '-' .. asString
    end
  end
  return asString
end

return BigInteger
