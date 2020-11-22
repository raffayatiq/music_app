module ApplicationHelper
	def auth_token
		"<input 
		type='hidden' 
		name='authenticity_token' 
		value=#{form_authenticity_token}
		/>".html_safe
	end

	def format_lyrics(lyrics)
		split_lyrics = lyrics.split(Regexp.union(["\r\n", "\n"]))
		html_safe_lyrics = split_lyrics.map { |sentence| html_escape(sentence) }
		html_safe_lyrics.join("<br>").html_safe
	end
end
