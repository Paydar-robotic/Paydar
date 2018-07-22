local function eagelTeaM(msg)
	if not is_mod(msg) then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local username = ''
		local chsh = 'addpm'..msg.to.id
		local hsh = redis:get(chsh)
		local chkpm = redis:get(msg.from.id..'chkuserpm'..msg.to.id)
		local add_lock = redis:hget('addmeminv', msg.to.id)
		if add_lock == 'on' then
			local setadd = redis:hget('addmemset', msg.to.id) or 10
			if msg.adduser then
				-- if you want can add robots, commented or deleted this codes
				if msg.content_.members_[0].type_.ID == 'UserTypeBot' then
					if not hsh then
						if not lang then
							tdbot.sendMessage(msg.to.id, 0, 1, '`💥You Added a Robot!`\n`Please Add a Human!` \n`Channel:`\n@PaydarTeam', 1, 'md')
						else
							tdbot.sendMessage(msg.to.id, 0, 1, '`💥شما یک ربات به گروه اضافه کردید`\n`لطفا یک کاربر عادی اضافه کنید`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
						end
					end
					return
				end
				-- check here
				if msg.from.username then
					username = '@'..check_markdown(msg.from.username)
				else
					username = check_markdown(msg.from.print_name)
				end
				if #msg.content_.members_ > 0 then
					if not hsh then
						if not lang then
							tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥You added` '..(#msg.content_.members_ + 1)..' users!_\n`But One user saved for you!`\n`Please add one by one user.`\n`Channel:`\n@PaydarTeam', 1, 'md')
						else
							tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥شما تعداد `'..(#msg.content_.members_ + 1)..'` کاربر را اضافه کردید!`\n`اما فقط یک کاربر برای شما ذخیره شد!`\n`لطفا کاربران رو تک به تک اضافه کنید تا محدودیت برای شما برداشته شود`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
						end
					end
				end
				local chash = msg.content_.members_[0].id_..'chkinvusr'..msg.from.id..'chat'..msg.to.id
				local chk = redis:get(chash)
				if not chk then
					redis:set(chash, true)
					local achash = 'addusercount'..msg.from.id
					local count = redis:hget(achash, msg.to.id) or 0
					redis:hset(achash, msg.to.id, (tonumber(count) + 1))
					local permit = redis:hget(achash, msg.to.id)
					if tonumber(permit) < tonumber(setadd) then
						local less = tonumber(setadd) - tonumber(permit)
						if not hsh then
							if not lang then
								tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥You invited`'..permit..'`users in this group.`\n`You must invite `'..less..'` other members.`\n`Channel:`\n@PaydarTeam', 1, 'md')
							else
								tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥شما تعداد `'..permit..'` کاربر را به این گروه اضافه کردید.`\n`باید`'..less..'` کاربر دیگر برای رفع محدودیت چت اضافه کنید.`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
							end
						end
					elseif tonumber(permit) == tonumber(setadd) then
						if not hsh then
							if not lang then
								tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥You can send messages now!`\n`Channel:`\n@PaydarTeam', 1, 'md')
							else
								tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥شما اکنون میتوانید پیام ارسال کنید.`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
							end
						end
					end
				else
					if not hsh then
						if not lang then
							tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥You already added this user!`\n`Channel:`\n@PaydarTeam', 1, 'md')
						else
							tdbot.sendMessage(msg.to.id, 0, 1, username..'\n`💥شما قبلا این کاربر را به گروه اضافه کرده اید!`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
						end
					end
				end
			end
			local permit = redis:hget('addusercount'..msg.from.id, msg.to.id) or 0
			if tonumber(permit) < tonumber(setadd) then
				tdbot.deleteMessages(msg.to.id, {[0] = msg.id}, dl_cb, nil)
				if not chkpm then
					redis:set(msg.from.id..'chkuserpm'..msg.to.id, true)
					if not lang then
						tdbot.sendMessage(msg.to.id, 0, 1, (check_markdown(msg.from.username) or msg.from.print_name)..'\n`💥You must add` '..setadd..' `users, so you can sending message!`\n`Channel:`\n@PaydarTeam', 1, 'md')
					else
						tdbot.sendMessage(msg.to.id, 0, 1, (check_markdown(msg.from.username) or msg.from.print_name)..'\n`💥شما باید` '..setadd..' `کاربر دیگر رابه به گروه دعوت کنید تا بتوانید پیام ارسال کنید`\n`کانال ما:`\n@PaydarTeam', 1, 'md')
					end
				end
			end
		end
	end
end

local function run(msg, parts)
	if is_mod(msg) then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		if parts[1]:lower() == 'unlock' or parts[1]:lower() == 'بازکردن' then
			if parts[2]:lower() == 'add' or parts[2]:lower() == 'اداجباری' then
				local add = redis:hget('addmeminv' ,msg.to.id)
				if not add then
					redis:hset('addmeminv', msg.to.id, 'off')
				end
				if add == 'on' then 
					redis:hset('addmeminv', msg.to.id, 'off')
					if not lang then
						return '`💥Limit Add Member Hash Been Unlocked`\n`Channel:`\n@PaydarTeam'
					else
						return '`💥محدودیت اضافه کردن کاربر غیرفعال شد`\n`کانال ما:`\n@PaydarTeam'
					end
				elseif add == 'off' then
					if not lang then
						return '`💥Limit Add Member Is Already Unlocked`\n`Channel:`\n@PaydarTeam'
					else
						return '`💥محدودیت اضافه کردن کاربر از قبل غیرفعال بود`\n`کانال ما:`\n@PaydarTeam'
					end
				end
			end
		end
		if parts[1]:lower() == 'lock' or parts[1]:lower() == 'قفل' then
			if parts[2]:lower() == 'add' or parts[2]:lower() == 'اداجباری' then
				local add = redis:hget('addmeminv' ,msg.to.id)
				if not add then
					redis:hset('addmeminv', msg.to.id, 'on')
				end
				if add == 'off' then 
					redis:hset('addmeminv', msg.to.id, 'on')
					if not lang then
						return '`💥Limit Add Member Hash Been Locked`\n`Channel:`\n@PaydarTeam'
					else
						return '`💥محدودیت اضافه کردن کاربر فعال شد`\n`کانال ما:`\n@PaydarTeam'
					end
				elseif add == 'on' then
					if not lang then
						return '💥Limit Add Member Is Already Locked`\n`Channel:`\n@PaydarTeam'
					else
						return '`💥محدودیت اضافه کردن کاربر از قبل فعال بود`\n`کانال ما:`\n@PaydarTeam'
					end
				end
			end
		end
		if parts[1]:lower() == 'setadd' or parts[1]:lower() == 'تنظیم اداجباری' and parts[2] then
			if tonumber(parts[2]) >= 1 and tonumber(parts[2]) <= 200 then
				redis:hset('addmemset', msg.to.id, parts[2])
				if not lang then
					return '`💥Add Member Limit Set To:'.. parts[2]..'`\n`Channel:`\n@PaydarTeam'
				else
					return '`💥تنظیم محدودیت اضافه کردن کاربر به: '.. parts[2]..'`\n`کانال ما:`\n@PaydarTeam'
				end
			else
				if not lang then
					return '`💥Range Number is between [1-200]`\n`Channel:`\n@PaydarTeam'
				else
					return '`💥تعداد اداجباری باید ما بین [200-1] باشد`\n`کانال ما:`\n@PaydarTeam'
				end
			end
		end
		if parts[1]:lower() == 'getadd' or parts[1]:lower() == 'تعداد اداجباری' then
			local getadd = redis:hget('addmemset', msg.to.id)
			if not lang then
				return '`💥Add Member Limit: '..getadd..'`\n`Channel:`\n@PaydarTeam'
			else
				return '`💥تعداد محدودیت اضافه کردن کاربر: '..getadd..'`\n`کانال ما:`\n@PaydarTeam'
			end
		end
		if parts[1]:lower() == 'addpm' or parts[1]:lower() == 'پیام اداجباری' then
			local hsh = 'addpm'..msg.to.id
			if parts[2] == 'on' or parts[2] == 'فعال' then
				redis:del(hsh)
				if not lang then
					return '`💥Add PM has been Activated`\n`Channel:`\n@PaydarTeam'
				else
					return '`💥ارسال پیام محدودیت اداجباری کاربر فعال شد`\n`کانال ما:`\n@PaydarTeam'
				end
			elseif parts[2] == 'off' or parts[2] == 'غیرفعال' then
				redis:set(hsh, true)
				if not lang then
					return '`💥Add PM has been Deactivated`\n`Channel:`\n@PaydarTeam'
				else
					return '`💥ارسال پیام محدودیت اداجباری کاربر غیرفعال شد`\n`کانال ما:`\n@PaydarTeam'
				end
			end
		end
	end
end
 
return {
  patterns = {
	'^[!/#]([Ll]ock) (.*)$',
	'^[!/#]([Uu]nlock) (.*)$',
	'^[!/#]([Aa]ddpm) (.*)$',
	'^[!/#]([Ss]etadd) (%d+)$',
	'^[!/#]([Gg]etadd)$',
	'^([Ll]ock) (.*)$',
	'^([Uu]nlock) (.*)$',
	'^([Aa]ddpm) (.*)$',
	'^([Ss]etadd) (%d+)$',
	'^([Gg]etadd)$',
	'^(قفل) (.*)$',
	'^(بازکردن) (.*)$',
	'^(پیام اداجباری) (.*)$',
	'^(تنظیم اداجباری) (%d+)$',
	'^(تعداد اداجباری)$',
  },
  run = run,
  pre_process = PaydarTeam
}
