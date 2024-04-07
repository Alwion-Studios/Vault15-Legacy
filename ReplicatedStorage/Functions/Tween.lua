return function (Object, Time, Style, Direction, RepeatCount, Repeat, Customization)
	game:GetService("TweenService"):Create(Object, TweenInfo.new(Time, Enum.EasingStyle[Style], Enum.EasingDirection[Direction], RepeatCount, Repeat, 0), Customization):Play()
end
