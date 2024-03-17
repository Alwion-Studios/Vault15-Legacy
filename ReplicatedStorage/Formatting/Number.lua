return function (v) 
	local pre, mid, post = tostring(v):match("(%-?%d?)(%d*)(%.?.*)")
	return pre..mid:reverse():gsub("(%d%d%d)", "%1,"):reverse()..post
end